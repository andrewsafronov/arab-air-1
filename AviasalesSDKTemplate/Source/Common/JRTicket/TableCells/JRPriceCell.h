//
//  JRPriceCell.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 16/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRPriceCell : UITableViewCell

@property (nonatomic, strong) id<JRSDKPrice> price;

@property (nonatomic, copy) void (^buyHandler)(id<JRSDKPrice> price);

@end
