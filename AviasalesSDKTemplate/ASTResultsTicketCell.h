//
//  ASTResultsTicketCell.h
//  AviasalesSDKTemplate
//
//  Created by Seva Billevich on 18.10.13.
//  Copyright (c) 2013 Go Travel Un Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JRSDKTicket;

@interface ASTResultsTicketCell : UITableViewCell

@property (strong, nonatomic) id<JRSDKTicket> ticket;

+ (NSString *)nibFileName;
+ (CGFloat)heightWithTicket:(id<JRSDKTicket>)ticket;

@end
