//
//  JRFilterTwoThumbSliderItem.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 07/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterItemProtocol.h"


@interface JRFilterTwoThumbSliderItem : NSObject <JRFilterItemProtocol>

@property (nonatomic, assign, readonly) NSTimeInterval minValue;
@property (nonatomic, assign, readonly) NSTimeInterval maxValue;
@property (nonatomic, assign, readonly) BOOL needDayTimeShowButtons;

@property (nonatomic, assign) NSTimeInterval currentMinValue;
@property (nonatomic, assign) NSTimeInterval currentMaxValue;

@property (nonatomic, copy) void (^filterAction)();

- (instancetype)initWithMinValue:(NSTimeInterval)minValue maxValue:(NSTimeInterval)maxValue currentMinValue:(NSTimeInterval)currentMinValue currentMaxValue:(NSTimeInterval)currentMaxValue;

@end


@interface JRFilterDelaysDurationItem : JRFilterTwoThumbSliderItem

@end


@interface JRFilterArrivalTimeItem : JRFilterTwoThumbSliderItem

@end


@interface JRFilterDepartureTimeItem : JRFilterTwoThumbSliderItem

@end