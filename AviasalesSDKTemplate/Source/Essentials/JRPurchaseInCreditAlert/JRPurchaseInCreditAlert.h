//
//  JRPurchaseInCreditAlert.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>


@protocol JRPurchaseInCreditAlertDelegate;


@interface JRPurchaseInCreditAlert : UIViewController

@property (nonatomic, weak) id <JRPurchaseInCreditAlertDelegate> delegate;

- (instancetype)initWithPrice:(id <JRSDKPrice>)price searchId:(NSString *)searchId;

- (void)show;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end


@protocol JRPurchaseInCreditAlertDelegate

- (void)purchaseInCreditAlert:(id)alert didTapPurchaseTicketWithPrice:(id <JRSDKPrice>)price purchaseURL:(NSURL *)purchaseURL;

@end