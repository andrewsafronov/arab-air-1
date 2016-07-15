//
//  JRSearchInfo.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>
#import "JRTravelSegment.h"
#import "JRSearchResult.h"

@interface JRSearchInfo : NSObject <JRSDKSearchInfo>

@property (nonatomic, retain) NSOrderedSet <JRTravelSegment *> *travelSegments;
@property (nonatomic, strong) JRSearchResult *searchResult;

@property (nonatomic, assign) BOOL adjustSearchInfo;

@property (nonatomic, strong) NSDate *returnDateForSimpleSearch;

@property (nonatomic, assign) JRSDKTravelClass travelClass;
@property (nonatomic, assign) NSInteger adults;
@property (nonatomic, assign) NSInteger children;
@property (nonatomic, assign) NSInteger infants;

- (BOOL)isComplexOpenJawSearch;
- (BOOL)isComplexSearch;
- (BOOL)isDirectReturnFlight;
- (BOOL)isValidSearchInfo;

- (void)cleanUp;

- (void)clipSearchInfoForComplexSearchIfNeeds;
- (void)clipSearchInfoForSimpleSearchIfNeeds;

- (void)addTravelSegment:(JRTravelSegment *)travelSegment;
- (void)removeTravelSegment:(JRTravelSegment *)travelSegment;
- (void)removeTravelSegmentsStartingFromTravelSegment:(JRTravelSegment *)travelSegment;

#pragma mark - Copying

- (JRSearchInfo *)copyWithTravelSegments;

#pragma mark Events

- (void)travelSegment:(JRTravelSegment *)travelSegment didSetOriginAirport:(id<JRSDKAirport>)originAirport;
- (void)travelSegment:(JRTravelSegment *)travelSegment didSetDestinationAirport:(id<JRSDKAirport>)destinationAirport;
- (void)travelSegment:(JRTravelSegment *)travelSegment didSetDepartureDate:(NSDate *)departureDate;

@end