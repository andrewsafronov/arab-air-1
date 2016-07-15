//
//  JRTicketUtils.m
//  AviasalesSDKTemplate
//
//  Created by Oleg on 12/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRTicketUtils.h"

@implementation JRTicketUtils

+ (NSString *)formattedTicketMinPriceInUserCurrency:(id<JRSDKTicket>)ticket {
    id<JRSDKPrice> const minPrice = [JRSDKModelUtils ticketMinPrice:ticket];
    NSNumber *const minPriceValue = [JRSDKModelUtils priceInUserCurrency:minPrice];
    return [AviasalesNumberUtil formatPrice:minPriceValue];
}

@end
