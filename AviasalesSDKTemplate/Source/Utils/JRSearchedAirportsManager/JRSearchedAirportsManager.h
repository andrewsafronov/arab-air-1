//
//  JRSearchedAirportsManager.h
//  AviasalesSDKTemplate
//
//  Created by Dmitry Ryumin on 06/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRSearchedAirportsManager : NSObject

+ (void)markSearchedAirport:(id<JRSDKAirport>)searchedAirport;

+ (NSArray<id<JRSDKAirport>> *)searchedAirports;

@end
