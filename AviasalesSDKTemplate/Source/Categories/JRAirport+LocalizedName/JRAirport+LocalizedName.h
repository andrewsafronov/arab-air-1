//
//  JRAirport+LocalizedName.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//


#import "JRAirport.h"

@interface JRAirport (LocalizedName)

+ (NSString *)localizedNameForAirport:(id <JRSDKAirport>)airport;

@end
