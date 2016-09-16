//
//  JRFilterListHeaderItem.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterItemProtocol.h"


@interface JRFilterListHeaderItem : NSObject <JRFilterItemProtocol> {
@protected
    NSInteger _itemsCount;
}

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


@interface JRFilterAirportsHeaderItem : JRFilterListHeaderItem

@end