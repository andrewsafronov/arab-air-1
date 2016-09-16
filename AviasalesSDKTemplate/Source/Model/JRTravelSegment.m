//
//  JRTravelSegment.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTravelSegment.h"
#import "JRSearchInfo.h"

@implementation JRTravelSegment

@synthesize departureDate;
@synthesize destinationAirport;
@synthesize originAirport;

static NSString * const kJRTravelSegmentOriginAirport = @"originAirport";
static NSString * const kJRTravelSegmentDestinationAirport = @"destinationAirport";
static NSString * const kJRTravelSegmentDepartureDate = @"departureDate";

- (instancetype)init {
    if (self = [super init]) {
        [self addPropertiesObservers];
    }
    
    return self;
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    [self addPropertiesObservers];
    
    return [super awakeAfterUsingCoder:aDecoder];
}

- (void)addPropertiesObservers {
    [self addObserver:self forKeyPath:kJRTravelSegmentOriginAirport options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:kJRTravelSegmentDestinationAirport options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:kJRTravelSegmentDepartureDate options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:kJRTravelSegmentOriginAirport context:NULL];
    [self removeObserver:self forKeyPath:kJRTravelSegmentDestinationAirport context:NULL];
    [self removeObserver:self forKeyPath:kJRTravelSegmentDepartureDate context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kJRTravelSegmentOriginAirport]) {
        [self.searchInfo travelSegment:self didSetOriginAirport:self.originAirport];
    } else if ([keyPath isEqualToString:kJRTravelSegmentDestinationAirport]) {
        [self.searchInfo travelSegment:self didSetDestinationAirport:self.destinationAirport];
    } else if ([keyPath isEqualToString:kJRTravelSegmentDepartureDate]) {
        [self.searchInfo travelSegment:self didSetDepartureDate:self.departureDate];
    }
}

- (BOOL)isValidSegment {
    if (self.originAirport &&
        self.destinationAirport &&
        [self.departureDate isKindOfClass:[NSDate class]] &&
        [JRSDKModelUtils airport:self.originAirport isEqualToAirport:self.destinationAirport] == NO) {
        return YES;
    }
    return NO;
}

#pragma mark - Copying

- (JRTravelSegment *)copy {
    JRTravelSegment *travelSegment = [JRTravelSegment new];
    travelSegment.departureDate = self.departureDate;
    travelSegment.destinationAirport = self.destinationAirport;
    travelSegment.originAirport = self.originAirport;
    
    return travelSegment;
}

@end
