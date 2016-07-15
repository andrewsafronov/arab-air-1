//
//  JRTicketVC.h
//  AviasalesSDKTemplate
//
//  Created by Seva Billevich on 21.10.13.
//  Copyright (c) 2013 Go Travel Un Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"

@interface JRTicketVC : JRViewController

@property (nonatomic, strong) id<JRSDKTicket> ticket;
@property (nonatomic, strong) id<JRSDKSearchInfo> searchInfo;

@property (nonatomic, weak) IBOutlet UIView *waitingView;
@property (nonatomic, weak) IBOutlet UILabel *waitingLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)updateContent;

@property (strong, nonatomic) NSString *searchId;

@end
