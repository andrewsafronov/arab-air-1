//
//  JRInfoPanelView.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 10/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRInfoPanelView : UIView

@property (nonatomic, strong) id<JRSDKTicket> ticket;

@property (nonatomic, copy) void (^buyHandler)(void);
@property (nonatomic, copy) void (^showOtherAgencyHandler)(void);

- (void)expand;
- (void)collapse;

@end
