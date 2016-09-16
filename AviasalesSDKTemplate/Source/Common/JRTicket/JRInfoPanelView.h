//
//  JRInfoPanelView.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>

@interface JRInfoPanelView : UIView

@property (nonatomic, strong) id<JRSDKTicket> ticket;

@property (nonatomic, copy) void (^buyHandler)(void);
@property (nonatomic, copy) void (^showOtherAgencyHandler)(void);
@property (nonatomic, copy) void (^buyInCreditHandler)(void);

- (void)expand;
- (void)collapse;

@end
