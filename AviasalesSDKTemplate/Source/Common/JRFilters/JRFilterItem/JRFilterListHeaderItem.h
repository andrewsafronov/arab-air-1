//
//  JRFilterListHeaderItem.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//


#import "JRFilterItemProtocol.h"


@interface JRFilterListHeaderItem : NSObject <JRFilterItemProtocol> {
@protected
    NSInteger _itemsCount;
}

@property (nonatomic, copy) void (^filterAction)();

@property (nonatomic, assign) BOOL expanded;


- (instancetype)initWithItemsCount:(NSInteger)count;

@end


@interface JRFilterGatesHeaderItem : JRFilterListHeaderItem

@end


@interface JRFilterPaymentMethodsHeaderItem : JRFilterListHeaderItem

@end


@interface JRFilterAirlinesHeaderItem : JRFilterListHeaderItem

@end


@interface JRFilterAllianceHeaderItem : JRFilterListHeaderItem

@end