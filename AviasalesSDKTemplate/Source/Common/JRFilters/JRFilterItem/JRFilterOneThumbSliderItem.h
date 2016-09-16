//
//  JRFilterOneThumbSliderItem.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterItemProtocol.h"


@interface JRFilterOneThumbSliderItem : NSObject <JRFilterItemProtocol>

@property (nonatomic, assign, readonly) CGFloat minValue;
@property (nonatomic, assign, readonly) CGFloat maxValue;

@property (nonatomic, assign) CGFloat currentValue;

@property (nonatomic, copy) void (^filterAction)();

- (instancetype)initWithMinValue:(CGFloat)minValue maxValue:(CGFloat)maxValue currentValue:(CGFloat)currentValue;

@end


@interface JRFilterPriceItem : JRFilterOneThumbSliderItem

@end


@interface JRFilterTotalDurationItem : JRFilterOneThumbSliderItem

@end
