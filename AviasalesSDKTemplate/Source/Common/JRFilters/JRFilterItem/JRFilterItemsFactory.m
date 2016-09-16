//
//  JRFilterItemsFactory.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//
#import "JRFilterItemsFactory.h"

#import "JRFilterItemProtocol.h"
#import "JRFilterOneThumbSliderItem.h"
#import "JRFilterTwoThumbSliderItem.h"
#import "JRFilterTravelSegmentItem.h"
#import "JRFilterCheckBoxItem.h"
#import "JRFilterListHeaderItem.h"
#import "JRFilterListSeparatorItem.h"

#import "JRFilter.h"
#import "JRFilterTicketBounds.h"
#import "JRFilterTravelSegmentBounds.h"


@interface JRFilterItemsFactory ()

@property (nonatomic, strong) JRFilter *filter;

@end


@implementation JRFilterItemsFactory

- (instancetype)initWithFilter:(JRFilter *)filter {
    self = [super init];
    if (self) {
        _filter = filter;
    }
    
    return self;
}

- (NSArray *)createSectionsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    NSMutableArray *sections = [NSMutableArray array];
    
    NSArray<id<JRFilterItemProtocol>> *stopoversItems = [self createStopoverItemsForFirstTravelSegment:travelSegment lastTravelSegment:nil];
    if (stopoversItems.count > 0) {
        [sections addObject:stopoversItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *durationsItems = [self createDurationsItemsForFirstTravelSegment:travelSegment lastTravelSegment:nil];
    if (durationsItems.count > 0) {
        [sections addObject:durationsItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *timesItems = [self createDepartureArrivalItemsForTravelSegment:travelSegment];
    if (timesItems.count > 0) {
        [sections addObject:timesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *airlinesItems = [self createAirlinesItemsForFirstTravelSegment:travelSegment lastTravelSegment:nil];
    if (airlinesItems.count > 0) {
        [sections addObject:airlinesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *alliancesItems = [self createAlliancesItemsForFirstTravelSegment:travelSegment lastTravelSegment:nil];
    if (alliancesItems.count > 0) {
        [sections addObject:alliancesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *airportsItems = [self createAirportsItemsForFirstTravelSegment:travelSegment lastTravelSegment:nil];
    if (airportsItems.count > 0) {
        [sections addObject:airportsItems];
    }
    
    return [sections copy];
}

- (NSArray *)createSectionsForComplexMode {
    NSMutableArray *sections = [NSMutableArray array];
    
    NSArray<id<JRFilterItemProtocol>> *priceItems = [self createPriceItems];
    if (priceItems.count > 0) {
        [sections addObject:priceItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *travelSegmentItems = [self createTravelSegmentItems];
    if (travelSegmentItems.count > 0) {
        for (id<JRFilterItemProtocol> item in travelSegmentItems) {
            [sections addObject:@[item]];
        }
    }
    
    NSArray<id<JRFilterItemProtocol>> *gatesItems = [self createGatesItems];
    if (gatesItems.count > 0) {
        [sections addObject:gatesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *paymentMethodsItems = [self createPaymentMethodsItems];
    if (paymentMethodsItems.count > 0) {
        [sections addObject:paymentMethodsItems];
    }
    
    return [sections copy];
}

- (NSArray *)createSectionsForSimpleMode {
    NSMutableArray *sections = [NSMutableArray array];
    id<JRSDKTravelSegment> firstTravelSegment = self.filter.travelSegmentsBounds.firstObject.travelSegment;
    id<JRSDKTravelSegment> lastTravelSegment = (self.filter.travelSegmentsBounds.count > 1) ? self.filter.travelSegmentsBounds.lastObject.travelSegment : nil;
    
    NSArray<id<JRFilterItemProtocol>> *stopoversItems = [self createStopoverItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    if (stopoversItems.count > 0) {
        [sections addObject:stopoversItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *priceItems = [self createPriceItems];
    if (priceItems.count > 0) {
        [sections addObject:priceItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *durationsItems = [self createDurationsItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    if (durationsItems.count > 0) {
        [sections addObject:durationsItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *timesToItems = [self createDepartureArrivalItemsForTravelSegment:firstTravelSegment];
    if (timesToItems.count > 0) {
        [sections addObject:timesToItems];
    }
    
    if (lastTravelSegment) {
        NSArray<id<JRFilterItemProtocol>> *timesFromItems = [self createDepartureArrivalItemsForTravelSegment:lastTravelSegment];
        if (timesFromItems.count > 0) {
            [sections addObject:timesFromItems];
        }
    }
    
    NSArray<id<JRFilterItemProtocol>> *airlinesItems = [self createAirlinesItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    if (airlinesItems.count > 0) {
        [sections addObject:airlinesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *alliancesItems = [self createAlliancesItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    if (alliancesItems.count > 0) {
        [sections addObject:alliancesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *airportsItems = [self createAirportsItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    if (airportsItems.count > 0) {
        [sections addObject:airportsItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *gatesItems = [self createGatesItems];
    if (gatesItems.count > 0) {
        [sections addObject:gatesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *paymentMethodsItems = [self createPaymentMethodsItems];
    if (paymentMethodsItems.count > 0) {
        [sections addObject:paymentMethodsItems];
    }
    
    return [sections copy];
}

#pragma mark - Private methds

- (NSArray<id<JRFilterItemProtocol>> *)createPriceItems {
    JRFilterTicketBounds *bounds = self.filter.ticketBounds;
    JRFilterPriceItem *item = [[JRFilterPriceItem alloc] initWithMinValue:bounds.minPrice
                                                                 maxValue:bounds.maxPrice
                                                             currentValue:bounds.filterPrice];
    
    typeof(item) __weak weakItem = item;
    item.filterAction = ^{
        bounds.filterPrice = weakItem.currentValue;
    };
    
    return @[item];
}

- (NSArray<id<JRFilterItemProtocol>> *)createTravelSegmentItems {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    
    for (JRFilterTravelSegmentBounds *travelSegmentBounds in self.filter.travelSegmentsBounds) {
        JRFilterTravelSegmentItem *item = [[JRFilterTravelSegmentItem alloc] initWithTravelSegment:travelSegmentBounds.travelSegment];
        [items addObject:item];
    }
    
    return [items copy];
}

- (NSArray<id<JRFilterItemProtocol>> *)createGatesItems {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTicketBounds *bounds = self.filter.ticketBounds;
    
    if (bounds.gates.count > 1) {
        JRFilterGatesHeaderItem *headerItem = [[JRFilterGatesHeaderItem alloc] initWithItemsCount:bounds.gates.count];
        [items addObject:headerItem];
        
        for (id<JRSDKGate> gate in self.filter.ticketBounds.gates) {
            JRFilterGateItem *item = [[JRFilterGateItem alloc] initWithGate:gate];
            item.selected = [bounds.filterGates containsObject:gate];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^{
                NSMutableOrderedSet<id<JRSDKGate>> *gates = [bounds.filterGates mutableCopy];
                if (!weakItem.selected && [gates containsObject:gate]) {
                    [gates removeObject:gate];
                    bounds.filterGates = [gates copy];
                } else if (weakItem.selected && ![gates containsObject:gate]) {
                    [gates addObject:gate];
                    bounds.filterGates = [gates copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return [items copy];
}

- (NSArray<id<JRFilterItemProtocol>> *)createPaymentMethodsItems {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTicketBounds *bounds = self.filter.ticketBounds;
    
    if (bounds.paymentMethods.count > 1) {
        JRFilterPaymentMethodsHeaderItem *headerItem = [[JRFilterPaymentMethodsHeaderItem alloc] initWithItemsCount:bounds.paymentMethods.count];
        [items addObject:headerItem];
        
        for (id<JRSDKPaymentMethod> paymentMethod in self.filter.ticketBounds.paymentMethods) {
            JRFilterPaymentMethodItem *item = [[JRFilterPaymentMethodItem alloc] initWithPaymentMethod:paymentMethod];
            item.selected = [bounds.filterPaymentMethods containsObject:paymentMethod];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^{
                NSMutableOrderedSet<id<JRSDKPaymentMethod>> *paymentMethods = [bounds.filterPaymentMethods mutableCopy];
                if (!weakItem.selected && [paymentMethods containsObject:paymentMethod]) {
                    [paymentMethods removeObject:paymentMethod];
                    bounds.filterPaymentMethods = [paymentMethods copy];
                } else if (weakItem.selected && ![paymentMethods containsObject:paymentMethod]) {
                    [paymentMethods addObject:paymentMethod];
                    bounds.filterPaymentMethods = [paymentMethods copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return [items copy];
}

- (NSArray<id<JRFilterItemProtocol>> *)createStopoverItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *firstSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:firstTravelSegment];
    JRFilterTravelSegmentBounds *lastSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:lastTravelSegment];
    
    NSMutableOrderedSet<NSNumber *> *transfersCounts = [firstSegmentBounds.transfersCounts mutableCopy];
    NSMutableOrderedSet<NSNumber *> *filterTransfersCounts = [firstSegmentBounds.filterTransfersCounts mutableCopy];
    NSMutableDictionary<NSNumber *, NSNumber *> *transfersCountsWitnMinPrice = [firstSegmentBounds.transfersCountsWitnMinPrice mutableCopy];
    if (lastSegmentBounds) {
        [transfersCounts unionOrderedSet:lastSegmentBounds.transfersCounts];
        [filterTransfersCounts unionOrderedSet:lastSegmentBounds.filterTransfersCounts];
        
        [lastSegmentBounds.transfersCountsWitnMinPrice enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
            NSNumber *curMinPrice = transfersCountsWitnMinPrice[key];
            if (!curMinPrice || obj.floatValue > curMinPrice.floatValue) {
                transfersCountsWitnMinPrice[key] = obj;
            }
        }];
    }
    
    if (transfersCounts.count > 1) {
        for (NSNumber *transfersCount in transfersCounts) {
            CGFloat minPrice = transfersCountsWitnMinPrice[transfersCount].floatValue;
            JRFilterStopoverItem *item = [[JRFilterStopoverItem alloc] initWithStopoverCount:transfersCount.integerValue minPrice:minPrice];
            item.selected = [filterTransfersCounts containsObject:transfersCount];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^{
                if (!weakItem.selected && [filterTransfersCounts containsObject:transfersCount]) {
                    [filterTransfersCounts removeObject:transfersCount];
                    firstSegmentBounds.filterTransfersCounts = [filterTransfersCounts copy];
                    lastSegmentBounds.filterTransfersCounts = [filterTransfersCounts copy];
                } else if (weakItem.selected && ![filterTransfersCounts containsObject:transfersCount]) {
                    [filterTransfersCounts addObject:transfersCount];
                    firstSegmentBounds.filterTransfersCounts = [filterTransfersCounts copy];
                    lastSegmentBounds.filterTransfersCounts = [filterTransfersCounts copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createDurationsItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *firstSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:firstTravelSegment];
    JRFilterTravelSegmentBounds *lastSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:lastTravelSegment];
    
    JRSDKFlightDuration minTotalDuration = firstSegmentBounds.minTotalDuration;
    JRSDKFlightDuration maxTotalDuration = firstSegmentBounds.maxTotalDuration;
    JRSDKFlightDuration filterTotalDuration = firstSegmentBounds.filterTotalDuration;
    
    JRSDKFlightDuration minDelaysDuration = firstSegmentBounds.minDelaysDuration;
    JRSDKFlightDuration maxDelaysDuration = firstSegmentBounds.maxDelaysDuration;
    JRSDKFlightDuration minFilterDelaysDuration = firstSegmentBounds.minFilterDelaysDuration;
    JRSDKFlightDuration maxFilterDelaysDuration = firstSegmentBounds.maxFilterDelaysDuration;
    
    if (lastSegmentBounds) {
        minTotalDuration = MIN(minTotalDuration, lastSegmentBounds.minTotalDuration);
        maxTotalDuration = MAX(maxTotalDuration, lastSegmentBounds.maxTotalDuration);
        filterTotalDuration = MAX(filterTotalDuration, lastSegmentBounds.filterTotalDuration);
        
        minDelaysDuration = MIN(minDelaysDuration, lastSegmentBounds.minDelaysDuration);
        maxDelaysDuration = MAX(maxDelaysDuration, lastSegmentBounds.maxDelaysDuration);
        minFilterDelaysDuration = MIN(minFilterDelaysDuration, lastSegmentBounds.minFilterDelaysDuration);
        maxFilterDelaysDuration = MAX(maxFilterDelaysDuration, lastSegmentBounds.maxFilterDelaysDuration);
    }
    
    if (minTotalDuration != maxTotalDuration) {
        JRFilterTotalDurationItem *totalDurationItem = [[JRFilterTotalDurationItem alloc] initWithMinValue:minTotalDuration
                                                                                                  maxValue:maxTotalDuration
                                                                                              currentValue:filterTotalDuration];
        
        typeof(totalDurationItem) __weak weakTotalDurationItem = totalDurationItem;
        totalDurationItem.filterAction = ^{
            firstSegmentBounds.filterTotalDuration = weakTotalDurationItem.currentValue;
            
            lastSegmentBounds.filterTotalDuration = weakTotalDurationItem.currentValue;
        };
        
        [items addObject:totalDurationItem];
    }
    
    if (minDelaysDuration != maxDelaysDuration) {
        JRFilterDelaysDurationItem *transferDurationItem = [[JRFilterDelaysDurationItem alloc] initWithMinValue:minDelaysDuration
                                                                                                       maxValue:maxDelaysDuration
                                                                                                currentMinValue:minFilterDelaysDuration
                                                                                                currentMaxValue:maxFilterDelaysDuration];
        
        typeof(transferDurationItem) __weak weakTransferDurationItem = transferDurationItem;
        transferDurationItem.filterAction = ^{
            firstSegmentBounds.minFilterDelaysDuration = weakTransferDurationItem.currentMinValue;
            firstSegmentBounds.maxFilterDelaysDuration = weakTransferDurationItem.currentMaxValue;
            
            lastSegmentBounds.minFilterDelaysDuration = weakTransferDurationItem.currentMinValue;
            lastSegmentBounds.maxFilterDelaysDuration = weakTransferDurationItem.currentMaxValue;
        };
        
        [items addObject:transferDurationItem];
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createDepartureArrivalItemsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:travelSegment];
    
    if (travelSegmentBounds.minDepartureTime != travelSegmentBounds.maxDepartureTime) {
        JRFilterDepartureTimeItem *departureItem = [[JRFilterDepartureTimeItem alloc] initWithMinValue:travelSegmentBounds.minDepartureTime
                                                                                              maxValue:travelSegmentBounds.maxDepartureTime
                                                                                       currentMinValue:travelSegmentBounds.minFilterDepartureTime
                                                                                       currentMaxValue:travelSegmentBounds.maxFilterDepartureTime];
        
        typeof(departureItem) __weak weakDepartureItem = departureItem;
        departureItem.filterAction = ^{
            travelSegmentBounds.minFilterDepartureTime = weakDepartureItem.currentMinValue;
            travelSegmentBounds.maxFilterDepartureTime = weakDepartureItem.currentMaxValue;
        };
        
        [items addObject:departureItem];
    }
    
    if (travelSegmentBounds.minArrivalTime != travelSegmentBounds.maxArrivalTime) {
        JRFilterArrivalTimeItem *arrivalItem = [[JRFilterArrivalTimeItem alloc] initWithMinValue:travelSegmentBounds.minArrivalTime
                                                                                        maxValue:travelSegmentBounds.maxArrivalTime
                                                                                 currentMinValue:travelSegmentBounds.minFilterArrivalTime
                                                                                 currentMaxValue:travelSegmentBounds.maxFilterArrivalTime];
        
        typeof(arrivalItem) __weak weakArrivalItem = arrivalItem;
        arrivalItem.filterAction = ^{
            travelSegmentBounds.minFilterArrivalTime = weakArrivalItem.currentMinValue;
            travelSegmentBounds.maxFilterArrivalTime = weakArrivalItem.currentMaxValue;
        };
        
        [items addObject:arrivalItem];
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createAirlinesItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *firstSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:firstTravelSegment];
    JRFilterTravelSegmentBounds *lastSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:lastTravelSegment];
    
    NSMutableOrderedSet<id<JRSDKAirline>> *airlines = [firstSegmentBounds.airlines mutableCopy];
    NSMutableOrderedSet<id<JRSDKAirline>> *filterAirlines = [firstSegmentBounds.filterAirlines mutableCopy];
    
    if (lastSegmentBounds) {
        [airlines unionOrderedSet:lastSegmentBounds.airlines];
        [filterAirlines unionOrderedSet:lastSegmentBounds.filterAirlines];
    }
    
    if (airlines.count > 1) {
        JRFilterAirlinesHeaderItem *headerItem = [[JRFilterAirlinesHeaderItem alloc] initWithItemsCount:airlines.count];
        [items addObject:headerItem];
        
        for (id<JRSDKAirline> airline in airlines) {
            JRFilterAirlineItem *item = [[JRFilterAirlineItem alloc] initWithAirline:airline];
            item.selected = [filterAirlines containsObject:airline];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^{
                if (!weakItem.selected && [filterAirlines containsObject:airline]) {
                    [filterAirlines removeObject:airline];
                    firstSegmentBounds.filterAirlines = [filterAirlines copy];
                    lastSegmentBounds.filterAirlines = [filterAirlines copy];
                } else if (weakItem.selected && ![filterAirlines containsObject:airline]) {
                    [filterAirlines addObject:airline];
                    firstSegmentBounds.filterAirlines = [filterAirlines copy];
                    lastSegmentBounds.filterAirlines = [filterAirlines copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createAlliancesItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *firstSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:firstTravelSegment];
    JRFilterTravelSegmentBounds *lastSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:lastTravelSegment];
    
    NSMutableOrderedSet<id<JRSDKAlliance>> *alliances = [firstSegmentBounds.alliances mutableCopy];
    NSMutableOrderedSet<id<JRSDKAlliance>> *filterAlliances = [firstSegmentBounds.filterAlliances mutableCopy];
    
    if (lastSegmentBounds) {
        [alliances unionOrderedSet:lastSegmentBounds.alliances];
        [filterAlliances unionOrderedSet:lastSegmentBounds.filterAlliances];
    }
    
    if (alliances.count > 1) {
        JRFilterAllianceHeaderItem *headerItem = [[JRFilterAllianceHeaderItem alloc] initWithItemsCount:alliances.count];
        [items addObject:headerItem];
        
        for (id<JRSDKAlliance> alliance in alliances) {
            JRFilterAllianceItem *item = [[JRFilterAllianceItem alloc] initWithAlliance:alliance];
            item.selected = [filterAlliances containsObject:alliance];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^{
                if (!weakItem.selected && [filterAlliances containsObject:alliance]) {
                    [filterAlliances removeObject:alliance];
                    firstSegmentBounds.filterAlliances = [filterAlliances copy];
                    lastSegmentBounds.filterAlliances = [filterAlliances copy];
                } else if (weakItem.selected && ![filterAlliances containsObject:alliance]) {
                    [filterAlliances addObject:alliance];
                    firstSegmentBounds.filterAlliances = [filterAlliances copy];
                    lastSegmentBounds.filterAlliances = [filterAlliances copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createAirportsItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    NSMutableArray<id<JRFilterItemProtocol>> *airportsItems = [NSMutableArray array];
    
    NSArray<id<JRFilterItemProtocol>> *originAirportsItems = [self createOriginAirportsItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    NSArray<id<JRFilterItemProtocol>> *stopoverAirportsItems = [self createStopoverAirportsItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    NSArray<id<JRFilterItemProtocol>> *destinationAirportsItems = [self createDestinationAirportsItemsForFirstTravelSegment:firstTravelSegment lastTravelSegment:lastTravelSegment];
    NSInteger count = 0;
    
    if (originAirportsItems.count > 1) {
        JRFilterListSeparatorItem *separatorItem = [[JRFilterListSeparatorItem alloc] initWithTitle:NSLS(@"JR_FILTER_AIRPORTS_ORIGIN")];
        [airportsItems addObject:separatorItem];
        [airportsItems addObjectsFromArray:originAirportsItems];
        count += originAirportsItems.count;
    }
    
    if (stopoverAirportsItems.count > 1) {
        JRFilterListSeparatorItem *separatorItem = [[JRFilterListSeparatorItem alloc] initWithTitle:NSLS(@"JR_FILTER_AIRPORTS_STOPOVER")];
        [airportsItems addObject:separatorItem];
        [airportsItems addObjectsFromArray:stopoverAirportsItems];
        count += stopoverAirportsItems.count;
    }
    
    if (destinationAirportsItems.count > 1) {
        JRFilterListSeparatorItem *separatorItem = [[JRFilterListSeparatorItem alloc] initWithTitle:NSLS(@"JR_FILTER_AIRPORTS_DESTINATION")];
        [airportsItems addObject:separatorItem];
        [airportsItems addObjectsFromArray:destinationAirportsItems];
        count += destinationAirportsItems.count;
    }
    
    if (count > 0) {
        JRFilterAirportsHeaderItem *headerItem = [[JRFilterAirportsHeaderItem alloc] initWithItemsCount:count];
        
        [items addObject:headerItem];
        [items addObjectsFromArray:airportsItems];
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createOriginAirportsItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *firstSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:firstTravelSegment];
    JRFilterTravelSegmentBounds *lastSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:lastTravelSegment];
    
    NSMutableOrderedSet<id<JRSDKAirport>> *originAirports = [firstSegmentBounds.originAirports mutableCopy];
    NSMutableOrderedSet<id<JRSDKAirport>> *filterOriginAirports = [firstSegmentBounds.filterOriginAirports mutableCopy];
    
    if (lastSegmentBounds) {
        [originAirports unionOrderedSet:lastSegmentBounds.originAirports];
        [filterOriginAirports unionOrderedSet:lastSegmentBounds.filterOriginAirports];
    }
    
    for (id<JRSDKAirport> airport in originAirports) {
        JRFilterAirportItem *item = [[JRFilterAirportItem alloc] initWithAirport:airport];
        item.selected = [filterOriginAirports containsObject:airport];
        
        typeof(item) __weak weakItem = item;
        item.filterAction = ^{
            if (!weakItem.selected && [filterOriginAirports containsObject:airport]) {
                [filterOriginAirports removeObject:airport];
                firstSegmentBounds.filterOriginAirports = [filterOriginAirports copy];
                lastSegmentBounds.filterOriginAirports = [filterOriginAirports copy];
            } else if (weakItem.selected && ![filterOriginAirports containsObject:airport]) {
                [filterOriginAirports addObject:airport];
                firstSegmentBounds.filterOriginAirports = [filterOriginAirports copy];
                lastSegmentBounds.filterOriginAirports = [filterOriginAirports copy];
            }
        };
        
        [items addObject:item];
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createStopoverAirportsItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *firstSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:firstTravelSegment];
    JRFilterTravelSegmentBounds *lastSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:lastTravelSegment];
    
    NSMutableOrderedSet<id<JRSDKAirport>> *stopoverAirports = [firstSegmentBounds.stopoverAirports mutableCopy];
    NSMutableOrderedSet<id<JRSDKAirport>> *filterStopoverAirports = [firstSegmentBounds.filterStopoverAirports mutableCopy];
    
    if (lastSegmentBounds) {
        [stopoverAirports unionOrderedSet:lastSegmentBounds.destinationAirports];
        [filterStopoverAirports unionOrderedSet:lastSegmentBounds.filterDestinationAirports];
    }
    
    for (id<JRSDKAirport> airport in stopoverAirports) {
        JRFilterAirportItem *item = [[JRFilterAirportItem alloc] initWithAirport:airport];
        item.selected = [filterStopoverAirports containsObject:airport];
        
        typeof(item) __weak weakItem = item;
        item.filterAction = ^{
            if (!weakItem.selected && [filterStopoverAirports containsObject:airport]) {
                [filterStopoverAirports removeObject:airport];
                firstSegmentBounds.filterStopoverAirports = [filterStopoverAirports copy];
                lastSegmentBounds.filterStopoverAirports = [filterStopoverAirports copy];
            } else if (weakItem.selected && ![filterStopoverAirports containsObject:airport]) {
                [filterStopoverAirports addObject:airport];
                firstSegmentBounds.filterStopoverAirports = [filterStopoverAirports copy];
                lastSegmentBounds.filterStopoverAirports = [filterStopoverAirports copy];
            }
        };
        
        [items addObject:item];
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createDestinationAirportsItemsForFirstTravelSegment:(id<JRSDKTravelSegment>)firstTravelSegment lastTravelSegment:(id<JRSDKTravelSegment>)lastTravelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *firstSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:firstTravelSegment];
    JRFilterTravelSegmentBounds *lastSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:lastTravelSegment];
    
    NSMutableOrderedSet<id<JRSDKAirport>> *destinationAirports = [firstSegmentBounds.destinationAirports mutableCopy];
    NSMutableOrderedSet<id<JRSDKAirport>> *filterDestinationAirports = [firstSegmentBounds.filterDestinationAirports mutableCopy];
    
    if (lastSegmentBounds) {
        [destinationAirports unionOrderedSet:lastSegmentBounds.destinationAirports];
        [filterDestinationAirports unionOrderedSet:lastSegmentBounds.filterDestinationAirports];
    }
    
    for (id<JRSDKAirport> airport in destinationAirports) {
        JRFilterAirportItem *item = [[JRFilterAirportItem alloc] initWithAirport:airport];
        item.selected = [filterDestinationAirports containsObject:airport];
        
        typeof(item) __weak weakItem = item;
        item.filterAction = ^{
            if (!weakItem.selected && [filterDestinationAirports containsObject:airport]) {
                [filterDestinationAirports removeObject:airport];
                firstSegmentBounds.filterDestinationAirports = [filterDestinationAirports copy];
                lastSegmentBounds.filterDestinationAirports = [filterDestinationAirports copy];
            } else if (weakItem.selected && ![filterDestinationAirports containsObject:airport]) {
                [filterDestinationAirports addObject:airport];
                firstSegmentBounds.filterDestinationAirports = [filterDestinationAirports copy];
                lastSegmentBounds.filterDestinationAirports = [filterDestinationAirports copy];
            }
        };
        
        [items addObject:item];
    }
    
    return items;
}

@end
