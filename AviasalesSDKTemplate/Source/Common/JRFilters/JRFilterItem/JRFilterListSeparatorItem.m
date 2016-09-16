//
//  JRFilterListSeparatorItem.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterListSeparatorItem.h"


@implementation JRFilterListSeparatorItem {
    NSString *_title;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = [title copy];
    }
    
    return self;
}

- (NSString *)tilte {
    return _title;
}

@end
