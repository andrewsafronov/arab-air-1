//
//  JRFilter.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilter.h"
#import "JRFilterTask.h"
#import "JRFilterBoundsBuilder.h"
#import "JRFilterTravelSegmentBounds.h"

#define kJRFilterLastTaskStartDelay 0.3


@interface JRFilter () <JRFilterTaskDelegate>

@property (nonatomic, strong) NSDate *lastTaskStartDate;

@end


@implementation JRFilter

- (instancetype)initWithSearchResults:(id<JRSDKSearchResult>)searchResults withSearchInfo:(id<JRSDKSearchInfo>)searchInfo {
    self = [super init];
    if (self) {
        _searchInfo = searchInfo;
        _searchResultsTickets = searchResults.strictSearchTickets;
        _filteredTickets = _searchResultsTickets;
        _lastTaskStartDate = [NSDate date];
        _travelSegmentsBounds = [NSMutableArray new];
        
        JRFilterBoundsBuilder *boundsBuilder = [[JRFilterBoundsBuilder alloc] initWithSearchResults:self.searchResultsTickets forSearchInfo:self.searchInfo];
        _ticketBounds = boundsBuilder.ticketBounds;
        _travelSegmentsBounds = boundsBuilder.travelSegmentsBounds;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(filterBoundsDidChange:)
                                                     name:kJRFilterBoundsDidChangeNotificationName
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public methds

- (BOOL)isAllBoundsReseted {
    if (!self.ticketBounds.isReseted) { return NO; }
    
    for (JRFilterTravelSegmentBounds *bounds in self.travelSegmentsBounds) {
        if (!bounds.isReseted) { return NO; }
    }
    
    return YES;
}

- (BOOL)isTravelSegmentBoundsResetedForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self travelSegmentBoundsForTravelSegment:travelSegment];
    
    return travelSegmentBounds.isReseted;
}

- (JRFilterTravelSegmentBounds *)travelSegmentBoundsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    for (JRFilterTravelSegmentBounds *travelSegmentBounds in self.travelSegmentsBounds) {
        if ([JRSDKModelUtils travelSegment:travelSegmentBounds.travelSegment isEqualToTravelSegment:travelSegment]) {
            return travelSegmentBounds;
        }
    }
    
    return nil;
}

- (id<JRSDKPrice>)minFilteredPrice {
    return self.filteredTickets.firstObject.prices.firstObject;
}

- (void)resetFilterBoundsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    JRFilterTravelSegmentBounds *travelSegmentBounds = [self travelSegmentBoundsForTravelSegment:travelSegment];
    
    [travelSegmentBounds resetBounds];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidResetNotificationName object:nil];
    });
}

- (void)resetAllBounds {
    NSMutableArray *boundsToReset = [self.travelSegmentsBounds mutableCopy];
    [boundsToReset addObject:self.ticketBounds];
    [self resetFilterBounds:boundsToReset];
}

- (void)resetFilterBounds:(NSArray *)boundsToReset {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [boundsToReset makeObjectsPerformSelector:@selector(resetBounds)];
#pragma clang diagnostic pop
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidResetNotificationName object:nil];
    });
    
    [self startNewFilteringTask];
}

#pragma mark - Private methds

- (void)filterBoundsDidChange:(NSNotification *)notification {
    if (notification.object == self.ticketBounds || [self.travelSegmentsBounds containsObject:notification.object]) {
        NSTimeInterval timeIntervalSinceLastTaskStartDate = [[NSDate date] timeIntervalSinceDate:self.lastTaskStartDate];
        if (timeIntervalSinceLastTaskStartDate > kJRFilterLastTaskStartDelay) {
            [self startNewFilteringTask];
        } else {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startNewFilteringTask) object:nil];
            [self performSelector:@selector(startNewFilteringTask) withObject:nil afterDelay:kJRFilterLastTaskStartDelay];
        }
    }
}

- (void)startNewFilteringTask {
    _lastTaskStartDate = [NSDate date];
    _filteringTask = nil;
    _filteringTask = [JRFilterTask filterTaskForTickets:self.searchResultsTickets
                                           ticketBounds:self.ticketBounds
                                    travelSegmentBounds:self.travelSegmentsBounds
                                           taskDelegate:self];
    
    __weak typeof(self.filteringTask) weakTask = self.filteringTask;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakTask performFiltering];
    });
}

#pragma mark - JRFilterTaskDelegate methds

- (void)filterTaskDidFinishWithTickets:(NSOrderedSet<id<JRSDKTicket>> *)filteredTickets {
    _filteredTickets = filteredTickets;
    
    __weak typeof(self) weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterMinPriceDidUpdateNotificationName object:self];
        
        [weakSelf.delegate filterDidUpdateFilteredObjects];
    });
}

@end
