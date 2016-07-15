//
//  JRFilterItemsFactory.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 23/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterItemsFactory.h"

#import "JRFilterItemProtocol.h"
#import "JRFilterOneThumbSliderItem.h"
#import "JRFilterTwoThumbSliderItem.h"
#import "JRFilterTravelSegmentItem.h"
#import "JRFilterCheckBoxItem.h"
#import "JRFilterListHeaderItem.h"

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
    
    NSArray<id<JRFilterItemProtocol>> *stopoversItems = [self createStopoverItemsForTravelSegment:travelSegment];
    if (stopoversItems.count > 0) {
        [sections addObject:stopoversItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *durationsItems = [self createDurationsItemsForTravelSegment:travelSegment];
    if (durationsItems.count > 0) {
        [sections addObject:durationsItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *timesItems = [self createDepartureArrivalItemsForTravelSegment:travelSegment];
    if (timesItems.count > 0) {
        [sections addObject:timesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *airlinesItems = [self createAirlinesItemsForTravelSegment:travelSegment];
    if (airlinesItems.count > 0) {
        [sections addObject:airlinesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *alliancesItems = [self createAlliancesItemsForTravelSegment:travelSegment];
    if (alliancesItems.count > 0) {
        [sections addObject:alliancesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *airportsItems = [self createAirportsItemsForTravelSegment:travelSegment];
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
    id<JRSDKTravelSegment> travelSegment = self.filter.travelSegmentsBounds.firstObject.travelSegment;
    NSMutableArray *sections = [NSMutableArray array];
    
    NSArray<id<JRFilterItemProtocol>> *stopoversItems = [self createStopoverItemsForTravelSegment:travelSegment];
    if (stopoversItems.count > 0) {
        [sections addObject:stopoversItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *priceItems = [self createPriceItems];
    if (priceItems.count > 0) {
        [sections addObject:priceItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *durationsItems = [self createDurationsItemsForTravelSegment:travelSegment];
    if (durationsItems.count > 0) {
        [sections addObject:durationsItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *timesToItems = [self createDepartureArrivalItemsForTravelSegment:travelSegment];
    if (timesToItems.count > 0) {
        [sections addObject:timesToItems];
    }
    
    if (self.filter.travelSegmentsBounds.count > 0) {
        id<JRSDKTravelSegment> fromTravelSegment = self.filter.travelSegmentsBounds.lastObject.travelSegment;
        NSArray<id<JRFilterItemProtocol>> *timesFromItems = [self createDepartureArrivalItemsForTravelSegment:fromTravelSegment];
        if (timesFromItems.count > 0) {
            [sections addObject:timesFromItems];
        }
    }
    
    NSArray<id<JRFilterItemProtocol>> *airlinesItems = [self createAirlinesItemsForTravelSegment:travelSegment];
    if (airlinesItems.count > 0) {
        [sections addObject:airlinesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *alliancesItems = [self createAlliancesItemsForTravelSegment:travelSegment];
    if (alliancesItems.count > 0) {
        [sections addObject:alliancesItems];
    }
    
    NSArray<id<JRFilterItemProtocol>> *airportsItems = [self createAirportsItemsForTravelSegment:travelSegment];
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
    item.filterAction = ^() {
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
            item.filterAction = ^() {
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
            item.filterAction = ^() {
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

- (NSArray<id<JRFilterItemProtocol>> *)createStopoverItemsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:travelSegment];
    
    if (travelSegmentBounds.transfersCounts.count > 1) {
        for (NSNumber *transfersCount in travelSegmentBounds.transfersCounts) {
            JRFilterStopoverItem *item = [[JRFilterStopoverItem alloc] initWithStopoverCount:transfersCount.integerValue];
            item.selected = [travelSegmentBounds.filterTransfersCounts containsObject:transfersCount];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^() {
                NSMutableOrderedSet<NSNumber *> *transfersCounts = [travelSegmentBounds.filterTransfersCounts mutableCopy];
                if (!weakItem.selected && [transfersCounts containsObject:transfersCount]) {
                    [transfersCounts removeObject:transfersCount];
                    travelSegmentBounds.filterTransfersCounts = [transfersCounts copy];
                } else if (weakItem.selected && ![transfersCounts containsObject:transfersCount]) {
                    [transfersCounts addObject:transfersCount];
                    travelSegmentBounds.filterTransfersCounts = [transfersCounts copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createDurationsItemsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:travelSegment];
    JRFilterTotalDurationItem *totalDurationItem = [[JRFilterTotalDurationItem alloc] initWithMinValue:travelSegmentBounds.minTotalDuration
                                                                                              maxValue:travelSegmentBounds.maxTotalDuration
                                                                                          currentValue:travelSegmentBounds.filterTotalDuration];
    
    typeof(totalDurationItem) __weak weakTotalDurationItem = totalDurationItem;
    totalDurationItem.filterAction = ^() {
        travelSegmentBounds.filterTotalDuration = weakTotalDurationItem.currentValue;
    };
    
    JRFilterDelaysDurationItem *transferDurationItem = [[JRFilterDelaysDurationItem alloc] initWithMinValue:travelSegmentBounds.minDelaysDuration
                                                                                                   maxValue:travelSegmentBounds.maxDelaysDuration
                                                                                            currentMinValue:travelSegmentBounds.minFilterDelaysDuration
                                                                                            currentMaxValue:travelSegmentBounds.maxFilterDelaysDuration];
    
    typeof(transferDurationItem) __weak weakTransferDurationItem = transferDurationItem;
    transferDurationItem.filterAction = ^() {
        travelSegmentBounds.minFilterDelaysDuration = weakTransferDurationItem.currentMinValue;
        travelSegmentBounds.maxFilterDelaysDuration = weakTransferDurationItem.currentMaxValue;
    };
    
    return @[totalDurationItem, transferDurationItem];
}

- (NSArray<id<JRFilterItemProtocol>> *)createDepartureArrivalItemsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:travelSegment];
    JRFilterDepartureTimeItem *departureItem = [[JRFilterDepartureTimeItem alloc] initWithMinValue:travelSegmentBounds.minDepartureTime
                                                                                          maxValue:travelSegmentBounds.maxDepartureTime
                                                                                   currentMinValue:travelSegmentBounds.minFilterDepartureTime
                                                                                   currentMaxValue:travelSegmentBounds.maxFilterDepartureTime];
    
    typeof(departureItem) __weak weakDepartureItem = departureItem;
    departureItem.filterAction = ^() {
        travelSegmentBounds.minFilterDepartureTime = weakDepartureItem.currentMinValue;
        travelSegmentBounds.maxFilterDepartureTime = weakDepartureItem.currentMaxValue;
    };
    
    JRFilterArrivalTimeItem *arrivalItem = [[JRFilterArrivalTimeItem alloc] initWithMinValue:travelSegmentBounds.minArrivalTime
                                                                                    maxValue:travelSegmentBounds.maxArrivalTime
                                                                             currentMinValue:travelSegmentBounds.minFilterArrivalTime
                                                                             currentMaxValue:travelSegmentBounds.maxFilterArrivalTime];
    
    typeof(arrivalItem) __weak weakArrivalItem = arrivalItem;
    arrivalItem.filterAction = ^() {
        travelSegmentBounds.minFilterArrivalTime = weakArrivalItem.currentMinValue;
        travelSegmentBounds.maxFilterArrivalTime = weakArrivalItem.currentMaxValue;
    };
    
    return @[departureItem, arrivalItem];
}

- (NSArray<id<JRFilterItemProtocol>> *)createAirlinesItemsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:travelSegment];
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    
    if (travelSegmentBounds.airlines.count > 1) {
        JRFilterAirlinesHeaderItem *headerItem = [[JRFilterAirlinesHeaderItem alloc] initWithItemsCount:travelSegmentBounds.airlines.count];
        [items addObject:headerItem];
        
        for (id<JRSDKAirline> airline in travelSegmentBounds.airlines) {
            JRFilterAirlineItem *item = [[JRFilterAirlineItem alloc] initWithAirline:airline];
            item.selected = [travelSegmentBounds.filterAirlines containsObject:airline];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^() {
                NSMutableOrderedSet<id<JRSDKAirline>> *airlines = [travelSegmentBounds.filterAirlines mutableCopy];
                if (!weakItem.selected && [airlines containsObject:airline]) {
                    [airlines removeObject:airline];
                    travelSegmentBounds.filterAirlines = [airlines copy];
                } else if (weakItem.selected && ![airlines containsObject:airline]) {
                    [airlines addObject:airline];
                    travelSegmentBounds.filterAirlines = [airlines copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createAlliancesItemsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self.filter travelSegmentBoundsForTravelSegment:travelSegment];
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    
    if (travelSegmentBounds.alliances.count > 1) {
        JRFilterAllianceHeaderItem *headerItem = [[JRFilterAllianceHeaderItem alloc] initWithItemsCount:travelSegmentBounds.alliances.count];
        [items addObject:headerItem];
        
        for (id<JRSDKAlliance> alliance in travelSegmentBounds.alliances) {
            JRFilterAllianceItem *item = [[JRFilterAllianceItem alloc] initWithAlliance:alliance];
            item.selected = [travelSegmentBounds.filterAlliances containsObject:alliance];
            
            typeof(item) __weak weakItem = item;
            item.filterAction = ^() {
                NSMutableOrderedSet<id<JRSDKAlliance>> *alliances = [travelSegmentBounds.filterAlliances mutableCopy];
                if (!weakItem.selected && [alliances containsObject:alliance]) {
                    [alliances removeObject:alliance];
                    travelSegmentBounds.filterAlliances = [alliances copy];
                } else if (weakItem.selected && ![alliances containsObject:alliance]) {
                    [alliances addObject:alliance];
                    travelSegmentBounds.filterAlliances = [alliances copy];
                }
            };
            
            [items addObject:item];
        }
    }
    
    return items;
}

- (NSArray<id<JRFilterItemProtocol>> *)createAirportsItemsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    NSMutableArray<id<JRFilterItemProtocol>> *items = [NSMutableArray array];
    
//    JRFilterListHeaderItem *headerItem = [JRFilterListHeaderItem new];
//    [items addObject:headerItem];
    
    return items;
}

@end
