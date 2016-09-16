//
//  JRGateBrowserVC.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRBrowserVC.h"

@class JRGateBrowserVC;


@protocol JRGateBrowserVCDelegate <NSObject>

@optional
- (void)gateBrowser:(JRGateBrowserVC *)gateBrowser didDismissWithSuccessfullLoading:(BOOL)isSuccessfullLoading;

@end


@interface JRGateBrowserVC : JRBrowserVC

@property(nonatomic, weak) id<JRGateBrowserVCDelegate> delegate;

- (void)setTicketPrice:(id<JRSDKPrice>)ticketPrice searchID:(NSString *)searchId;
@property (nonatomic, strong, readonly) id<JRSDKPrice> ticketPrice;

@end


@interface JRLeakAvoider : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> delegate;

- (id)initWithDelegate:(id<WKScriptMessageHandler>)delegate;

@end
