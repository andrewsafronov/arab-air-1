//
//  ASTResultsTicketPriceCell.h
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 26.05.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASTResultsTicketPriceCell : UITableViewCell
@property (strong, nonatomic) id<JRSDKPrice> price;
@property (strong, nonatomic) id<JRSDKAirline> airline;
+ (NSString *)nibFileName;
+ (CGFloat)height;
@end
