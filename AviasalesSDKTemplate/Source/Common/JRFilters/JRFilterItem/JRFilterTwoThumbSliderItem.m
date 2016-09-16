//
//  JRFilterTwoThumbSliderItem.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterTwoThumbSliderItem.h"

#import "DateUtil.h"


@implementation JRFilterTwoThumbSliderItem

- (instancetype)initWithMinValue:(NSTimeInterval)minValue maxValue:(NSTimeInterval)maxValue currentMinValue:(NSTimeInterval)currentMinValue currentMaxValue:(NSTimeInterval)curentMaxValue {
    self = [super init];
    if (self) {
        _minValue = minValue;
        _maxValue = maxValue;
        _currentMinValue = currentMinValue;
        _currentMaxValue = curentMaxValue;
    }
    
    return self;
}

- (BOOL)needDayTimeShowButtons {
    return NO;
}

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return @"";
}

- (NSAttributedString *)attributedStringValue {
    return [[NSAttributedString alloc] initWithString:@""];
}

@end


@implementation JRFilterDelaysDurationItem

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return NSLS(@"JR_FILTER_DELAY_DURATION");
}

- (NSAttributedString *)attributedStringValue {
    NSString *minTimeString = [DateUtil duration:self.currentMinValue durationStyle:JRDateUtilDurationLongStyle];
    NSString *maxTimeString = [DateUtil duration:self.currentMaxValue durationStyle:JRDateUtilDurationLongStyle];
    NSString *text = [NSString stringWithFormat:@"%@ %@ \n %@ %@",
                      NSLS(@"JR_FILTER_TOTAL_DURATION_FROM"), minTimeString,
                      NSLS(@"JR_FILTER_TOTAL_DURATION_PRIOR_UP_TO"), maxTimeString];
    
    return [[NSAttributedString alloc] initWithString:text];
}

@end


@implementation JRFilterArrivalTimeItem

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return NSLS(@"JR_FILTER_ARRIVAL_TIME");
}

- (NSAttributedString *)attributedStringValue {
    NSString *minTime = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMinValue]];
    NSString *maxTime = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMaxValue]];
    NSString *minDate = [DateUtil dayMonthStringFromDate:[NSDate dateWithTimeIntervalSince1970:self.currentMinValue]];
    NSString *maxDate = [DateUtil dayMonthStringFromDate:[NSDate dateWithTimeIntervalSince1970:self.currentMaxValue]];
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@ \n %@ %@ %@",
                      NSLS(@"JR_FILTER_TOTAL_TIME_FROM"), minTime, minDate,
                      NSLS(@"JR_FILTER_TOTAL_DURATION_PRIOR_TO"), maxTime, maxDate];
    
    return [[NSAttributedString alloc] initWithString:text];
}

@end


@implementation JRFilterDepartureTimeItem

- (BOOL)needDayTimeShowButtons {
    return YES;
}

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return NSLS(@"JR_FILTER_DEPARTURE_TIME");
}

- (NSAttributedString *)attributedStringValue {
    NSString *minDate = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMinValue]];
    NSString *maxDate = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMaxValue]];
    NSString *text = [NSString stringWithFormat:@"%@ %@ \n %@ %@",
                      NSLS(@"JR_FILTER_TOTAL_TIME_FROM"), minDate,
                      NSLS(@"JR_FILTER_TOTAL_DURATION_PRIOR_TO"), maxDate];
    
    return [[NSAttributedString alloc] initWithString:text];
}

@end
