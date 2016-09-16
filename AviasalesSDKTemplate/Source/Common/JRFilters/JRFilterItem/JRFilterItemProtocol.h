//
//  JRFilterItemProtocol.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//


#import <Foundation/Foundation.h>


@protocol JRFilterItemProtocol <NSObject>

- (NSString *)tilte;

@optional

@property (nonatomic, copy) void (^filterAction)();

- (NSString *)detailsTitle;
- (NSAttributedString *)attributedStringValue;

@end

