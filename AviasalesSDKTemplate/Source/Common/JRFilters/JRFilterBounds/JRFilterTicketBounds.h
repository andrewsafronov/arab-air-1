//
//  JRFilterTicketBounds.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 30/03/14.
//
//

#import <Foundation/Foundation.h>

@interface JRFilterTicketBounds : NSObject

@property (assign, nonatomic) BOOL mobileWebOnly;
@property (assign, nonatomic) BOOL filterMobileWebOnly;

@property (assign, nonatomic) NSInteger minPrice;    // In USD
@property (assign, nonatomic) NSInteger maxPrice;    // In USD
@property (assign, nonatomic) NSInteger filterPrice; // In USD

@property (strong, nonatomic) NSOrderedSet<id<JRSDKGate>> *gates;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKGate>> *filterGates;

@property (strong, nonatomic) NSOrderedSet<id<JRSDKPaymentMethod>> *paymentMethods;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKPaymentMethod>> *filterPaymentMethods;

@property (nonatomic, assign, readonly) BOOL isReseted;

- (void)resetBounds;

@end
