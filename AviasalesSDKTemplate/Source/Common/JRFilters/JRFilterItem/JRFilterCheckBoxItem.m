//
//  JRFilterCheckBoxItem.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 07/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterCheckBoxItem.h"
#import "DateUtil.h"


@implementation JRFilterCheckBoxItem

- (BOOL)showAverageRate {
    return NO;
}

- (NSInteger)rating {
    return 0;
}

- (NSString *)tilte {
    return @"";
}

- (NSAttributedString *)attributedStringValue {
    return [[NSAttributedString alloc] initWithString:@""];
}

@end



@implementation JRFilterStopoverItem {
    NSInteger _stopoverCount;
}

- (instancetype)initWithStopoverCount:(NSInteger)stopoverCount {
    self = [super init];
    if (self) {
        _stopoverCount = stopoverCount;
    }
    
    return self;
}

- (NSString *)tilte {
    if (_stopoverCount == 0) {
        return NSLS(@"JR_TRANSFERS##{zero}");
    }
    
    NSString *format = NSLSP(@"JR_TRANSFERS", _stopoverCount);
    return [NSString stringWithFormat:format, _stopoverCount];
}

- (NSAttributedString *)attributedStringValue {
    NSString *timeString = [DateUtil duration:1 durationStyle:JRDateUtilDurationLongStyle];
    NSString *text = [NSString stringWithFormat:@"%@ %@", NSLS(@"JR_FILTER_CELL_TO_TEXT"), timeString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    return attributedText;
}

@end


@implementation JRFilterGateItem {
    id<JRSDKGate> _gate;
}

- (instancetype)initWithGate:(id<JRSDKGate>)gate {
    self = [super init];
    if (self) {
        _gate = gate;
    }
    
    return self;
}

- (NSString *)tilte {
    return _gate.label;
}

@end


@implementation JRFilterPaymentMethodItem {
    id<JRSDKPaymentMethod> _paymentMethod;
}

- (instancetype)initWithPaymentMethod:(id<JRSDKPaymentMethod>)paymentMethod {
    self = [super init];
    if (self) {
        _paymentMethod = paymentMethod;
    }
    
    return self;
}

- (NSString *)tilte {
    return _paymentMethod.name;
}

@end


@implementation JRFilterAirlineItem  {
    id<JRSDKAirline> _airline;
}

- (instancetype)initWithAirline:(id<JRSDKAirline>)airline {
    self = [super init];
    if (self) {
        _airline = airline;
    }
    
    return self;
}

- (BOOL)showAverageRate {
    return YES;
}

- (NSInteger)rating {
    return _airline.averageRate.integerValue;
}

- (NSString *)tilte {
    return _airline.name;
}

@end


@implementation JRFilterAllianceItem {
    id<JRSDKAlliance> _alliance;
}

- (instancetype)initWithAlliance:(id<JRSDKAlliance>)alliance {
    self = [super init];
    if (self) {
        _alliance = alliance;
    }
    
    return self;
}

- (NSString *)tilte {
    return _alliance.name;
}

@end
