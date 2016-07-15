//
//  JRFilterListHeaderItem.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
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
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_SECTIONS_GATES_TITLE"), (long)_itemsCount];
}

@end


@implementation JRFilterPaymentMethodsHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_SECTIONS_PAYMENT_METHODS_TITLE"), (long)_itemsCount];
}
            
@end


@implementation JRFilterAirlinesHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_SECTIONS_AIRLINES_TITLE"), (long)_itemsCount];
}

@end


@implementation JRFilterAllianceHeaderItem

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ %ld", NSLS(@"JR_FILTER_SECTIONS_ALLIANCES_TITLE"), (long)_itemsCount];
}

@end