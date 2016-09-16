//
//  JRFilterListSeparatorItem.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterItemProtocol.h"


@interface JRFilterListSeparatorItem : NSObject <JRFilterItemProtocol>

- (instancetype)initWithTitle:(NSString *)title;

@end
