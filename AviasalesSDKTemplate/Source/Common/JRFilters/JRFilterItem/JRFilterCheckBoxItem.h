//
//  JRFilterCheckBoxItem.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 07/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRFilterItemProtocol.h"


@interface JRFilterCheckBoxItem : NSObject <JRFilterItemProtocol>

@property (nonatomic, copy) void (^filterAction)();

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign, readonly) BOOL showAverageRate;
@property (nonatomic, assign, readonly) NSInteger rating;

@end


@interface JRFilterStopoverItem : JRFilterCheckBoxItem

- (instancetype)initWithStopoverCount:(NSInteger)stopoverCount;

@end


@interface JRFilterGateItem : JRFilterCheckBoxItem

- (instancetype)initWithGate:(id<JRSDKGate>)gate;

@end


@interface JRFilterPaymentMethodItem : JRFilterCheckBoxItem

- (instancetype)initWithPaymentMethod:(id<JRSDKPaymentMethod>)paymentMethod;

@end


@interface JRFilterAirlineItem : JRFilterCheckBoxItem

- (instancetype)initWithAirline:(id<JRSDKAirline>)airline;

@end


@interface JRFilterAllianceItem : JRFilterCheckBoxItem

- (instancetype)initWithAlliance:(id<JRSDKAlliance>)alliance;

@end



