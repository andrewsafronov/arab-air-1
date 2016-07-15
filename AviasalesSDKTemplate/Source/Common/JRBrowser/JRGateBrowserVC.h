//
//  JRGateBrowserVC.h
//  Aviasales iOS Apps
//
//  Created by Dmitry Ryumin on 02/04/14.
//
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
