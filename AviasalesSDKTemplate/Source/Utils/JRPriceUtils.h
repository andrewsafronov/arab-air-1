//
//  JRPriceUtils.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 13/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRPriceUtils : NSObject

+ (NSString *)formattedPriceInUserCurrency:(id<JRSDKPrice>)price;

@end
