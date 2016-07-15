//
//  JRFilterTravelSegmentItem.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterItemProtocol.h"


@class JRFilter;

@interface JRFilterTravelSegmentItem : NSObject <JRFilterItemProtocol>

@property (strong, nonatomic, readonly) id<JRSDKTravelSegment> travelSegment;

@property (nonatomic, copy) void (^filterAction)();

- (instancetype)initWithTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

@end
