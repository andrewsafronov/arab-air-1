//
//  JRTicketVC.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>
#import "JRViewController.h"

@interface JRTicketVC : JRViewController

@property (nonatomic, strong) id<JRSDKTicket> ticket;
@property (nonatomic, strong) id<JRSDKSearchInfo> searchInfo;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void)updateContent;

@property (strong, nonatomic) NSString *searchId;

@end
