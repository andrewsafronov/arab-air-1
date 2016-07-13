//
// Created by Ilya Amelchenkov on 06.11.15.
// Copyright (c) 2015 aviasales. All rights reserved.
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