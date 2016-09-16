//
//  JRPriceCell.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>

@interface JRPriceCell : UITableViewCell

@property (nonatomic, strong) id<JRSDKPrice> price;

@property (nonatomic, copy) void (^buyHandler)(id<JRSDKPrice> price);

@end
