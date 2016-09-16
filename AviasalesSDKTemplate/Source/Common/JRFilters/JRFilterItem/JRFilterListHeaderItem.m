//
//  JRFilterListHeaderItem.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterListHeaderItem.h"


@implementation JRFilterListHeaderItem

- (instancetype)initWithItemsCount:(NSInteger)count {
    self = [super init];
    if (self) {
        _itemsCount = count;
    }
    
    return self;
}

- (NSString *)tilte {
    return @"";
}

@end


@implementation JRFilterGatesHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_GATES"), (long)_itemsCount];
}

@end


@implementation JRFilterPaymentMethodsHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_PAYMENT_METHODS"), (long)_itemsCount];
}
            
@end


@implementation JRFilterAirlinesHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_AIRLINES"), (long)_itemsCount];
}

@end


@implementation JRFilterAllianceHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_ALLIANCES"), (long)_itemsCount];
}

@end


@implementation JRFilterAirportsHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_AIRPORTS"), (long)_itemsCount];
}

@end