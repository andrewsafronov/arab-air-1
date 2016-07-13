//
//  JRAirport+LocalizedName.m
//  AviasalesSDKTemplate
//
//  Created by Dmitry Ryumin on 07/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRAirport+LocalizedName.h"

@implementation JRAirport (LocalizedName)

+ (NSString *)localizedNameForAirport:(id <JRSDKAirport>)airport {
    if ([airport isCity]) {
        return NSLS(@"AVIASALES_ANY_AIRPORT");
    } else {
        return airport.airportName;
    }
}

@end
