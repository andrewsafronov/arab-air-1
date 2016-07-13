//
//  JRAirport+LocalizedName.h
//  AviasalesSDKTemplate
//
//  Created by Dmitry Ryumin on 07/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRAirport.h"

@interface JRAirport (LocalizedName)

+ (NSString *)localizedNameForAirport:(id <JRSDKAirport>)airport;

@end
