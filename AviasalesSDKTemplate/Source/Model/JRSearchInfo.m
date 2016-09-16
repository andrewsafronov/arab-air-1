//
//  JRSearchInfo.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchInfo.h"
#import "DateUtil.h"

#define DEFAULT_ADULTS_COUNT 1

@implementation JRSearchInfo

@synthesize searchResult;

- (instancetype)init {
    if (self = [super init]) {
        _adults = DEFAULT_ADULTS_COUNT;
    }
    
    return self;
}

- (NSDate *)returnDateForSimpleSearch {
    if ([self.travelSegments count] > 1) {
        return ((JRTravelSegment *)(self.travelSegments)[1]).departureDate;
    }
    return nil;
}

- (void)setReturnDateForSimpleSearch:(NSDate *)returnDateForSimpleSearch {
    if ([self.travelSegments count] > 1) {
        ((JRTravelSegment *)(self.travelSegments)[1]).departureDate = returnDateForSimpleSearch;
    }
}

- (NSString *)marker {
    //TODO
    return nil;
}

#pragma mark - SearchInfo Identity

- (BOOL)isDirectReturnFlight {
    JRTravelSegment *firstTS = self.travelSegments.firstObject;
    JRTravelSegment *secondTS = self.travelSegments.lastObject;
    if (self.travelSegments.count == 2 &&
        [[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:firstTS.originAirport.iata] isEqualToString:[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:secondTS.destinationAirport.iata]] &&
        [[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:firstTS.destinationAirport.iata] isEqualToString:[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:secondTS.originAirport.iata]]) {
        if (firstTS.departureDate &&
            secondTS.departureDate) {
            return YES;
        } else if (!firstTS.departureDate &&
                   !secondTS.departureDate) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (BOOL)isComplexSearch {
    JRSearchInfo *searchInfo = self;
    if (searchInfo.travelSegments.count <= 1) {
        return NO;
    } else if (searchInfo.travelSegments.count == 2) {
        
        JRTravelSegment *firstTravelSegment = searchInfo.travelSegments.firstObject;
        JRTravelSegment *secondTravelSegment = searchInfo.travelSegments.lastObject;
        
        
        if ([[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:firstTravelSegment.originAirport.iata] isEqualToString:[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:secondTravelSegment.destinationAirport.iata]] &&
            [[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:firstTravelSegment.destinationAirport.iata] isEqualToString:[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:secondTravelSegment.originAirport.iata]]) {
            return NO;
        } else if (secondTravelSegment.originAirport == nil ||
                   secondTravelSegment.destinationAirport == nil ||
                   secondTravelSegment.departureDate == nil) {
            return NO;
        }
        return YES;
    } else {
        return YES;
    }
    
}

- (BOOL)isComplexOpenJawSearch {
    BOOL isComplexSearch = [self isComplexSearch];
    if (isComplexSearch) {
        BOOL isOpenJawSearch = YES;
        JRTravelSegment *prevTravelSegment;
        for (JRTravelSegment *currentTravelSegment in self.travelSegments.copy) {
            if (prevTravelSegment) {
                if ([[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:prevTravelSegment.destinationAirport.iata]
                     isEqualToString:[[[AviasalesSDK sharedInstance] airportsStorage] mainIATAByIATA:currentTravelSegment.originAirport.iata]] == NO) {
                    isOpenJawSearch = NO;
                }
            }
            prevTravelSegment = currentTravelSegment;
        }
        return isOpenJawSearch;
    } else {
        return NO;
    }
}

- (BOOL)isValidSearchInfo {
    if (self.adults < 1 || self.adults > 9 || self.children > 9 || self.infants > 9) {
        return NO;
    }
    if (self.travelClass != JRSDKTravelClassEconomy &&
               self.travelClass != JRSDKTravelClassBusiness &&
               self.travelClass != JRSDKTravelClassPremiumEconomy &&
               self.travelClass != JRSDKTravelClassFirst) {
        return NO;
    }
    for (JRTravelSegment *travelSegment in self.travelSegments) {
        if (travelSegment.isValidSegment == NO) {
            return NO;
        }
    }
    NSDate *prevDate = nil;
    for (JRTravelSegment *travelSegment in self.travelSegments) {
        if (prevDate && travelSegment.departureDate) {
            if ([travelSegment.departureDate compare:prevDate] == NSOrderedAscending) {
                return NO;
            }
        }
        
        if (travelSegment.departureDate) {
            prevDate = travelSegment.departureDate;
        }
    }
    return YES;
}

#pragma mark - Travel segments operations

- (void)cleanUp {
    NSDate *prevDate = nil;
    
    for (JRTravelSegment *travelSegment in self.travelSegments) {
        if (travelSegment.departureDate) {
            
            NSDate *departureDate = [DateUtil systemTimeZoneResetTimeForDate:travelSegment.departureDate];
            NSDate *firstAvalibleForSearchDate = [DateUtil firstAvalibleForSearchDate];
            NSDate *lastAvalibleForSearchDate = [DateUtil nextYearDate:[DateUtil firstAvalibleForSearchDate]];
            NSDate *tomorrow = [DateUtil systemTimeZoneResetTimeForDate:[DateUtil nextDayForDate:[NSDate date]]];
            if ([lastAvalibleForSearchDate compare:tomorrow] == NSOrderedAscending) {
                tomorrow = lastAvalibleForSearchDate;
            }
            if (departureDate && ([departureDate compare:prevDate ? prevDate : firstAvalibleForSearchDate] == NSOrderedAscending ||
                                  [departureDate compare:lastAvalibleForSearchDate] == NSOrderedDescending )) {
                [travelSegment setDepartureDate:prevDate ? prevDate : tomorrow];
            }
            
            if (prevDate && [travelSegment.departureDate compare:prevDate] == NSOrderedAscending) {
                [travelSegment setDepartureDate:tomorrow];
            } else {
                prevDate = travelSegment.departureDate;
            }
            
        }
    }
}

- (void)clipSearchInfoForSimpleSearchIfNeeds {
    NSDate *returnDate = [self returnDateForSimpleSearch];
    JRTravelSegment *directTravelSegment = self.travelSegments.firstObject;
    
    [self removeTravelSegmentsStartingFromTravelSegment:directTravelSegment];
    
    [self addTravelSegment:directTravelSegment];
    
    if (returnDate) {
        JRTravelSegment *returnTravelSegment = [JRTravelSegment new];
        [returnTravelSegment setOriginAirport:directTravelSegment.destinationAirport];
        [returnTravelSegment setDestinationAirport:directTravelSegment.originAirport];
        [returnTravelSegment setDepartureDate:returnDate];
        [self addTravelSegment:returnTravelSegment];
    }
}

- (void)clipSearchInfoForComplexSearchIfNeeds {
    for (JRTravelSegment *travelSegment in self.travelSegments) {
        if (!travelSegment.originAirport || !travelSegment.destinationAirport || !travelSegment.departureDate) {
            [self removeTravelSegmentsStartingFromTravelSegment:travelSegment];
            break;
        }
    }
}

- (void)addTravelSegment:(JRTravelSegment *)travelSegment {
    JRTravelSegment *prevTravelSegment = self.travelSegments.lastObject;
    NSMutableOrderedSet *travelSegments = [NSMutableOrderedSet new];
    [travelSegments addObjectsFromArray:self.travelSegments.array];
    [travelSegments addObject:travelSegment];
    [self setTravelSegments:travelSegments];
    if (self.adjustSearchInfo == YES) {
        [self travelSegment:prevTravelSegment didSetDestinationAirport:prevTravelSegment.destinationAirport];
    }
    
    travelSegment.searchInfo = self;
}

- (void)removeTravelSegment:(JRTravelSegment *)travelSegment {
    JRTravelSegment *prevTravelSegment = nil;
    if (self.adjustSearchInfo == YES) {
        prevTravelSegment = [self prevTravelSegmentForTravelSegment:travelSegment];
    }
    NSMutableOrderedSet *travelSegments = [NSMutableOrderedSet new];
    [travelSegments addObjectsFromArray:self.travelSegments.array];
    [travelSegments removeObject:travelSegment];
    [self setTravelSegments:travelSegments];
    [prevTravelSegment setDestinationAirport:prevTravelSegment.destinationAirport];
 
    travelSegment.searchInfo = nil;
}

- (void)removeTravelSegmentsStartingFromTravelSegment:(JRTravelSegment *)travelSegment {
    if ([travelSegment isKindOfClass:[JRTravelSegment class]]) {
        
        NSOrderedSet *travelSegments = self.travelSegments;
        NSUInteger startIndex = [travelSegments indexOfObject:travelSegment];
        if (startIndex != NSNotFound) {
            NSUInteger endIndex = travelSegments.count;
            NSArray *travelSegmentsToDelete = [[NSOrderedSet orderedSetWithOrderedSet:travelSegments
                                                                                range:NSMakeRange(startIndex, endIndex - startIndex)
                                                                            copyItems:NO] array];
            for (JRTravelSegment *travelSegmentToDelete in travelSegmentsToDelete) {
                [self removeTravelSegment:travelSegmentToDelete];
            }
        }
    }
}

#pragma mark - Travel Segments Changes

- (void)travelSegment:(JRTravelSegment *)travelSegment didSetOriginAirport:(id<JRSDKAirport>)originAirport {
    if (self.adjustSearchInfo == NO) {
        return;
    }
    if (travelSegment && originAirport) {
        JRTravelSegment *prevTravelSegment = [self prevTravelSegmentForTravelSegment:travelSegment];
        if (prevTravelSegment.destinationAirport == nil && ![JRSDKModelUtils airport:prevTravelSegment.destinationAirport isEqualToAirport:originAirport]) {
            [prevTravelSegment setDestinationAirport:originAirport];
        }
    }
}

- (void)travelSegment:(JRTravelSegment *)travelSegment didSetDestinationAirport:(id<JRSDKAirport>)destinationAirport {
    if (self.adjustSearchInfo == NO) {
        return;
    }
    if (travelSegment && destinationAirport) {
        
        JRTravelSegment *prevTravelSegment = [self prevTravelSegmentForTravelSegment:travelSegment];
        [prevTravelSegment setDestinationAirport:prevTravelSegment.destinationAirport];
        
        JRTravelSegment *nextTravelSegment = [self nextTravelSegmentForTravelSegment:travelSegment];
        if (nextTravelSegment.originAirport == nil &&
            ![JRSDKModelUtils airport:nextTravelSegment.originAirport isEqualToAirport:destinationAirport]) {
            [nextTravelSegment setOriginAirport:destinationAirport];
        }
    }
}

- (void)travelSegment:(JRTravelSegment *)travelSegment didSetDepartureDate:(NSDate *)departureDate {
    if (self.adjustSearchInfo == NO) {
        return;
    }
    if (travelSegment && departureDate) {
        NSUInteger travelSegmentIndex = [self.travelSegments indexOfObject:travelSegment];
        for (JRTravelSegment *segment in self.travelSegments) {
            NSUInteger segmentIndex = [self.travelSegments indexOfObject:segment];
            if (segmentIndex > travelSegmentIndex && segment.departureDate) {
                NSComparisonResult result = [departureDate compare:segment.departureDate];
                if (result == NSOrderedDescending) {
                    [segment setDepartureDate:departureDate];
                }
            }
        }
    }
}

- (JRTravelSegment *)prevTravelSegmentForTravelSegment:(JRTravelSegment *)travelSegment {
    NSUInteger prevTravelSegmentIndex = [self.travelSegments indexOfObject:travelSegment] - 1;
    if (self.travelSegments.count > prevTravelSegmentIndex) {
        return (self.travelSegments)[prevTravelSegmentIndex];
    } else {
        return nil;
    }
}

- (JRTravelSegment *)nextTravelSegmentForTravelSegment:(JRTravelSegment *)travelSegment {
    NSUInteger nextTravelSegmentIndex = [self.travelSegments indexOfObject:travelSegment] + 1;
    if (self.travelSegments.count > nextTravelSegmentIndex) {
        return (self.travelSegments)[nextTravelSegmentIndex];
    } else {
        return nil;
    }
}

#pragma mark - Copying

- (JRSearchInfo *)copyWithTravelSegments {
    JRSearchInfo *searchInfoWithTravelSegments = [JRSearchInfo new];
    searchInfoWithTravelSegments.travelClass = self.travelClass;
    searchInfoWithTravelSegments.adults = self.adults;
    searchInfoWithTravelSegments.children = self.children;
    searchInfoWithTravelSegments.infants = self.infants;
    
    NSMutableOrderedSet *orderedTravelSegments = [NSMutableOrderedSet new];
    for (JRTravelSegment *travelSegment in self.travelSegments) {
        [orderedTravelSegments addObject:[travelSegment copy]];
    }
    
    [searchInfoWithTravelSegments setTravelSegments:orderedTravelSegments];
    
    return searchInfoWithTravelSegments;
}

@end
