//
//  JRFilterTask.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterTask.h"
#import "JRFilterTicketBounds.h"
#import "JRTicket.h"
#import "JRGate.h"
#import "JRPaymentMethod.h"
#import "JRFilterTravelSegmentBounds.h"
#import "JRSearchInfo.h"
#import "JRFlightSegment.h"
#import "DateUtil.h"
#import "JRAirline.h"
#import "JRAirport.h"
#import "JRAlliance.h"
#import "JRFlight.h"
#import "JRFilter.h"


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
    NSMutableOrderedSet<id<JRSDKTicket>> *ticketsToRemove = [NSMutableOrderedSet orderedSet];
    
    for (id<JRSDKTicket> ticket in self.ticketsToFilter) {
        NSMutableOrderedSet<id<JRSDKPrice>> *pricesToRemove = [NSMutableOrderedSet orderedSet];
        for (id<JRSDKPrice> price in ticket.prices) {
            NSUInteger priceValue = [JRSDKModelUtils priceInUSD:ticket.prices.firstObject].integerValue;
            
            if (priceValue > self.ticketBounds.filterPrice) {
                [pricesToRemove addObject:price];
            } else if (![self.ticketBounds.filterGates containsObject: price.gate]) {
                [pricesToRemove addObject:price];
            } else if (self.ticketBounds.filterPaymentMethods.count > 0 &&  price.gate.paymentMethods > 0) {
                if (![ price.gate.paymentMethods isSubsetOfSet:self.ticketBounds.filterPaymentMethods.set]) {
                    [pricesToRemove addObject:price];
                }
            }
        }
        
        if (pricesToRemove.count == ticket.prices.count) {
            [ticketsToRemove addObject:ticket];
        } else {
            if ([self needRemoveTicketAfterTravelSegmentBoundsWereApplied:ticket]) {
                [ticketsToRemove addObject:ticket];
            }
        }
    }
    
    NSMutableOrderedSet<id<JRSDKTicket>> *filteredTickets = [self.ticketsToFilter mutableCopy];
    [filteredTickets minusOrderedSet:ticketsToRemove];
    
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
            
            if (![stopoverAirports isSubsetOfSet:travelSegmentBounds.stopoverAirports.set]) {
                needRemove = YES;
                break;
            }
        }
    }
    
    return needRemove;
}

@end
