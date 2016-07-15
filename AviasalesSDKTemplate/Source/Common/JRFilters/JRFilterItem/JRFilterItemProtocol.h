//
//  JRFilterItemProtocol.h
//  Aviasales iOS Apps
//
//  Created by Oleg on 06/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.


#import <Foundation/Foundation.h>


@protocol JRFilterItemProtocol <NSObject>

@property (nonatomic, copy) void (^filterAction)();

- (NSString *)tilte;

@optional
- (NSString *)detailsTitle;
- (NSAttributedString *)attributedStringValue;

@end

