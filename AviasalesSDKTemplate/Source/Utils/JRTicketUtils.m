//
//  JRTicketUtils.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTicketUtils.h"

@implementation JRTicketUtils

+ (NSString *)formattedTicketMinPriceInUserCurrency:(id<JRSDKTicket>)ticket {
    id<JRSDKPrice> const minPrice = [JRSDKModelUtils ticketMinPrice:ticket];
    NSNumber *const minPriceValue = [JRSDKModelUtils priceInUserCurrency:minPrice];
    return [AviasalesNumberUtil formatPrice:minPriceValue];
}

@end
