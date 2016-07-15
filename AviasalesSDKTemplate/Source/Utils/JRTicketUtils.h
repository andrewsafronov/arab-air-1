//
//  JRTicketUtils.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 12/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JRTicketUtils : NSObject

+ (NSString *)formattedTicketMinPriceInUserCurrency:(id<JRSDKPrice>)price;

@end
