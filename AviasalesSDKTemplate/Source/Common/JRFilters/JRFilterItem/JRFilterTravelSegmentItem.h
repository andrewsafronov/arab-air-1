//
//  JRFilterTravelSegmentItem.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterItemProtocol.h"


@class JRFilter;

@interface JRFilterTravelSegmentItem : NSObject <JRFilterItemProtocol>

@property (strong, nonatomic, readonly) id<JRSDKTravelSegment> travelSegment;

@property (nonatomic, copy) void (^filterAction)();

- (instancetype)initWithTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

@end
