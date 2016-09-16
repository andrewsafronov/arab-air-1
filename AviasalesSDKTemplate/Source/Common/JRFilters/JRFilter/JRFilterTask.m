//
//  JRFilterTask.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterTask.h"
#import "JRFilterTicketBounds.h"
#import "JRFilterTravelSegmentBounds.h"
#import "DateUtil.h"
#import "JRTicket.h"


@interface JRFilterTask ()

@property (weak, nonatomic) JRFilterTicketBounds *ticketBounds;
@property (weak, nonatomic) NSArray *travelSegmentBounds;
@property (weak, nonatomic) id<JRFilterTaskDelegate> delegate;
@property (weak, nonatomic) NSOrderedSet<id<JRSDKTicket>> *ticketsToFilter;

@end


@implementation JRFilterTask

+ (instancetype)filterTaskForTickets:(NSOrderedSet<id<JRSDKTicket>> *)ticketsToFilter
                        ticketBounds:(JRFilterTicketBounds *)ticketBounds
                 travelSegmentBounds:(NSArray *)travelSegmentBounds
                        taskDelegate:(id<JRFilterTaskDelegate>)delegate {
    return [[JRFilterTask alloc] initFilterTaskForTickets:ticketsToFilter
                                             ticketBounds:ticketBounds
                                      travelSegmentBounds:travelSegmentBounds
                                             taskDelegate:delegate];
}

- (instancetype)initFilterTaskForTickets:(NSOrderedSet<id<JRSDKTicket>> *)ticketsToFilter
                            ticketBounds:(JRFilterTicketBounds *)ticketBounds
                     travelSegmentBounds:(NSArray *)travelSegmentBounds
                            taskDelegate:(id<JRFilterTaskDelegate>)delegate {
    self = [super init];
    if (self) {
        _ticketBounds = ticketBounds;
        _ticketsToFilter = ticketsToFilter;
        _travelSegmentBounds = travelSegmentBounds;
        _delegate = delegate;
    }
    return self;
}

- (void)performFiltering {
    NSMutableOrderedSet<id<JRSDKTicket>> *filteredTickets = [NSMutableOrderedSet orderedSet];
    
    for (id<JRSDKTicket> ticket in self.ticketsToFilter) {
        NSMutableOrderedSet<id<JRSDKPrice>> *filteredPrices = [ticket.prices mutableCopy];
        JRTicket *filteredTicket = [JRTicket ticketByCopyingFieldsFromTicket:ticket];
        
        for (id<JRSDKPrice> price in ticket.prices) {
            CGFloat priceValue = [JRSDKModelUtils priceInUSD:price].floatValue;
            
            if (priceValue > self.ticketBounds.filterPrice) {
                [filteredPrices removeObject:price];
            } else if (![self.ticketBounds.filterGates containsObject:price.gate]) {
                [filteredPrices removeObject:price];
            } else if (self.ticketBounds.filterPaymentMethods.count > 0 &&  price.gate.paymentMethods > 0) {
                if (![ price.gate.paymentMethods isSubsetOfSet:self.ticketBounds.filterPaymentMethods.set]) {
                    [filteredPrices removeObject:price];
                }
            }
        }
        
        if (filteredPrices.count > 0) {
            if (![self needRemoveTicketAfterTravelSegmentBoundsWereApplied:ticket]) {
                filteredTicket.prices = filteredPrices;
                [filteredTickets addObject:filteredTicket];
            }
        }
    }
    
    [self.delegate filterTaskDidFinishWithTickets:filteredTickets];
}

- (BOOL)needRemoveTicketAfterTravelSegmentBoundsWereApplied:(id<JRSDKTicket>)ticket {
    BOOL needRemove = NO;
    
    for (JRFilterTravelSegmentBounds *travelSegmentBounds in self.travelSegmentBounds) {
        NSInteger indexOfTravelSegment = [self.travelSegmentBounds indexOfObject:travelSegmentBounds];
        id<JRSDKFlightSegment> flightSegment = [ticket.flightSegments objectAtIndex:indexOfTravelSegment];
        
        if (travelSegmentBounds.filterTotalDuration < flightSegment.totalDurationInMinutes) {
            needRemove = YES;
            break;
        }
        
        if (travelSegmentBounds.minFilterDelaysDuration > flightSegment.delayDurationInMinutes || travelSegmentBounds.maxFilterDelaysDuration < flightSegment.delayDurationInMinutes) {
            needRemove = YES;
            break;
        }
        
        if (travelSegmentBounds.minFilterDepartureTime > flightSegment.departureDateTimestamp.doubleValue || travelSegmentBounds.maxFilterDepartureTime < flightSegment.departureDateTimestamp.doubleValue) {
            needRemove = YES;
            break;
        }
        
        if (travelSegmentBounds.minFilterArrivalTime > flightSegment.arrivalDateTimestamp.doubleValue || travelSegmentBounds.maxFilterArrivalTime < flightSegment.arrivalDateTimestamp.doubleValue) {
            needRemove = YES;
            break;
        }
        
        if (flightSegment.flights.count > 0) {
            if (![travelSegmentBounds.filterTransfersCounts containsObject:@(flightSegment.flights.count - 1)]) {
                needRemove = YES;
                break;
            }
        }
        
        NSSet<id<JRSDKAirline>> *flightSegmentAirlines = [flightSegment.flights valueForKeyPath:@"airline"];
        if (![flightSegmentAirlines isSubsetOfSet:travelSegmentBounds.filterAirlines.set]) {
            needRemove = YES;
            break;
        }
        
        NSSet<id<JRSDKAlliance>> *flightSegmentAlliances = [flightSegment.flights valueForKeyPath:@"airline.alliance"];
        if (![flightSegmentAlliances isSubsetOfSet:travelSegmentBounds.filterAlliances.set]) {
            needRemove = YES;
            break;
        }
        
        id<JRSDKAirport> originAirport = flightSegment.flights.firstObject.originAirport;
        if (![travelSegmentBounds.filterOriginAirports containsObject:originAirport]) {
            needRemove = YES;
            break;
        }
        
        id<JRSDKAirport> destinationAirport = flightSegment.flights.lastObject.destinationAirport;
        if (![travelSegmentBounds.filterDestinationAirports containsObject:destinationAirport]) {
            needRemove = YES;
            break;
        }
        
        if (flightSegment.flights.count > 1) {
            NSMutableSet<id<JRSDKAirport>> *stopoverAirports = [NSMutableSet set];
            for (id<JRSDKFlight> flight in flightSegment.flights) {
                for (id<JRSDKAirport> airport in @[flight.originAirport, flight.destinationAirport]) {
                    if (![JRSDKModelUtils airport:airport isEqualToAirport:originAirport] && ![JRSDKModelUtils airport:airport isEqualToAirport:destinationAirport]) {
                        [stopoverAirports addObject:airport];
                    }
                }
            }
            
            if (![stopoverAirports isSubsetOfSet:travelSegmentBounds.filterStopoverAirports.set]) {
                needRemove = YES;
                break;
            }
        }
    }
    
    return needRemove;
}

@end
