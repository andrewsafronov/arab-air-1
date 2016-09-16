//
//  JRAirport+LocalizedName.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//


#import "JRAirport+LocalizedName.h"

@implementation JRAirport (LocalizedName)

+ (NSString *)localizedNameForAirport:(id <JRSDKAirport>)airport {
    if ([airport isCity]) {
        return NSLS(@"JR_ANY_AIRPORT");
    } else {
        return airport.airportName;
    }
}

@end
