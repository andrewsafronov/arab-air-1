//
//  JRFilterTwoThumbSliderItem.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 07/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
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
    return NSLS(@"JR_FILTER_TRANSFER_DURATION_CELL_TITLE");
}

- (NSAttributedString *)attributedStringValue {
    NSString *minTimeString = [DateUtil duration:self.currentMinValue durationStyle:JRDateUtilDurationLongStyle];
    NSString *maxTimeString = [DateUtil duration:self.currentMaxValue durationStyle:JRDateUtilDurationLongStyle];
    NSString *text = [NSString stringWithFormat:@"%@ %@ \n %@ %@", NSLS(@"JR_FILTER_CELL_FROM_TEXT"), minTimeString, NSLS(@"JR_FILTER_CELL_TO_TEXT"), maxTimeString];
    
    return [[NSAttributedString alloc] initWithString:text];
}

@end


@implementation JRFilterArrivalTimeItem

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return NSLS(@"JR_FILTER_ARRIVAL_CELL_TITLE");
}

- (NSAttributedString *)attributedStringValue {
    NSString *minTime = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMinValue]];
    NSString *maxTime = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMaxValue]];
    NSString *minDate = [DateUtil dayMonthStringFromDate:[NSDate dateWithTimeIntervalSince1970:self.currentMinValue]];
    NSString *maxDate = [DateUtil dayMonthStringFromDate:[NSDate dateWithTimeIntervalSince1970:self.currentMaxValue]];
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@ \n %@ %@ %@",
                      NSLS(@"JR_FILTER_CELL_FROM_TEXT"), minTime, minDate,
                      NSLS(@"JR_FILTER_CELL_TO_TEXT"), maxTime, maxDate];
    
    return [[NSAttributedString alloc] initWithString:text];
}

@end


@implementation JRFilterDepartureTimeItem

- (BOOL)needDayTimeShowButtons {
    return YES;
}

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return NSLS(@"JR_FILTER_DEPARTURE_CELL_TITLE");
}

- (NSAttributedString *)attributedStringValue {
    NSString *minDate = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMinValue]];
    NSString *maxDate = [DateUtil dateToTimeString:[NSDate dateWithTimeIntervalSince1970:self.currentMaxValue]];
    NSString *text = [NSString stringWithFormat:@"%@ %@ \n %@ %@",
                      NSLS(@"JR_FILTER_CELL_FROM_TEXT"), minDate,
                      NSLS(@"JR_FILTER_CELL_TO_TEXT"), maxDate];
    
    return [[NSAttributedString alloc] initWithString:text];
}

@end
