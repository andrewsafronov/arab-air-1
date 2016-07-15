//
//  JRPriceUtils.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 13/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRPriceUtils.h"

@implementation JRPriceUtils

+ (NSString *)formattedPriceInUserCurrency:(id<JRSDKPrice>)price {
    NSNumber *const minPriceValue = [JRSDKModelUtils priceInUserCurrency:price];
    return [AviasalesNumberUtil formatPrice:minPriceValue];
}

@end
