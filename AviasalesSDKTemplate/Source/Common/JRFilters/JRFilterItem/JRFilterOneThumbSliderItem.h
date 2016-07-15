//
//  JRFilterOneThumbSliderItem.h
//  Aviasales iOS Apps
//
//  Created by Oleg on 06/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterItemProtocol.h"


@interface JRFilterOneThumbSliderItem : NSObject <JRFilterItemProtocol>

@property (nonatomic, assign, readonly) NSInteger minValue;
@property (nonatomic, assign, readonly) NSInteger maxValue;

@property (nonatomic, assign) NSInteger currentValue;

@property (nonatomic, copy) void (^filterAction)();

- (instancetype)initWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue currentValue:(NSInteger)currentValue;

@end


@interface JRFilterPriceItem : JRFilterOneThumbSliderItem

@end


@interface JRFilterTotalDurationItem : JRFilterOneThumbSliderItem

@end
