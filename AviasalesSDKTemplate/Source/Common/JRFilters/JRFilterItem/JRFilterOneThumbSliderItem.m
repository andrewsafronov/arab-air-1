//
//  JRFilterOneThumbSliderItem.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 06/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterOneThumbSliderItem.h"

#import "DateUtil.h"


@implementation JRFilterOneThumbSliderItem

- (instancetype)initWithMinValue:(NSInteger)minValue maxValue:(NSInteger)maxValue currentValue:(NSInteger)currentValue {
    self = [super init];
    if (self) {
        _minValue = minValue;
        _maxValue = maxValue;
        _currentValue = currentValue;
    }
    
    return self;
}

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return @"";
}

- (NSAttributedString *)attributedStringValue {
    return [[NSAttributedString alloc] initWithString:@""];
}

@end


@implementation JRFilterPriceItem

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return NSLS(@"JR_FILTER_PRICE_CELL_TITLE");
}

- (NSAttributedString *)attributedStringValue {
    JRSDKCurrency const userCurrency = [AviasalesSDK sharedInstance].currencyCode;
    NSNumber *priceInUserCurrency = [AviasalesNumberUtil convertPrice:@(self.currentValue) fromCurrency:@"usd" to:userCurrency];
    NSString *priceString = [NSString stringWithFormat:@"%ld", (long)priceInUserCurrency.integerValue];
    NSString *text = [NSString stringWithFormat:@"%@ %@", NSLS(@"JR_FILTER_CELL_TO_TEXT"), priceString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    NSString *currencyCode = [AviasalesSDK sharedInstance].currencyCode.uppercaseString;
    NSString *currencyString = [NSString stringWithFormat:@"\u00A0%@", currencyCode];
    NSAttributedString *currencyAttributedString = [[NSAttributedString alloc] initWithString:currencyString attributes:nil];
    [attributedText appendAttributedString:currencyAttributedString];
    
    NSRange currencyRange = [attributedText.string rangeOfString:currencyString];
    if (currencyRange.location != NSNotFound) {
        UIFont *currencyFont = [UIFont systemFontOfSize:8.0];
        [attributedText addAttribute:NSFontAttributeName value:currencyFont range:currencyRange];
        [attributedText addAttribute:NSBaselineOffsetAttributeName value:@6 range:currencyRange];
    }
    
    return attributedText;
}

@end


@implementation JRFilterTotalDurationItem

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return NSLS(@"JR_FILTER_TOTAL_DURATION_CELL_TITLE");
}

- (NSAttributedString *)attributedStringValue {
    NSString *timeString = [DateUtil duration:self.currentValue durationStyle:JRDateUtilDurationLongStyle];
    NSString *text = [NSString stringWithFormat:@"%@ %@", NSLS(@"JR_FILTER_CELL_TO_TEXT"), timeString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    return attributedText;
}

@end
