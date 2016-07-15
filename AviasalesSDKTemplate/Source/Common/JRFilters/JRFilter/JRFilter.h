//
//  JRFilter.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterTask.h"

#define kJRFilterBoundsDidChangeNotificationName    @"kJRFilterBoundsDidChangeNotificationName"
#define kJRFilterBoundsDidResetNotificationName     @"kJRFilterBoundsDidResetNotificationName"
#define kJRFilterMinPriceDidUpdateNotificationName  @"kJRFilterMinPriceDidUpdateNotificationName"


@class JRFilterTravelSegmentBounds;
@class JRFilterTicketBounds;

@protocol JRFilterDelegate<NSObject>

@required
- (void)filterDidUpdateFilteredObjects;

@end


@interface JRFilter : NSObject

@property (nonatomic, strong, readonly) JRFilterTicketBounds *ticketBounds;
@property (nonatomic, strong, readonly) NSArray<JRFilterTravelSegmentBounds *> *travelSegmentsBounds;

@property (nonatomic, strong, readonly) NSOrderedSet<id<JRSDKTicket>> *searchResultsTickets;
@property (nonatomic, strong, readonly) NSOrderedSet<id<JRSDKTicket>> *filteredTickets;

@property (nonatomic, strong, readonly) id<JRSDKPrice> minFilteredPrice;
@property (nonatomic, strong, readonly) id<JRSDKSearchInfo> searchInfo;
@property (nonatomic, strong, readonly) JRFilterTask *filteringTask;

@property (nonatomic, assign, readonly) BOOL isAllBoundsReseted;

@property (nonatomic, weak) id <JRFilterDelegate> delegate;

- (instancetype)initWithSearchResults:(id<JRSDKSearchResult>)searchResults withSearchInfo:(id<JRSDKSearchInfo>)searchInfo;

- (void)resetAllBounds;
- (void)resetFilterBoundsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment;
- (JRFilterTravelSegmentBounds *)travelSegmentBoundsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment;
- (BOOL)isTravelSegmentBoundsResetedForTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

@end
