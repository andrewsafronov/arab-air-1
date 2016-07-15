//
//  JRSearchedAirportsManager.m
//  AviasalesSDKTemplate
//
//  Created by Dmitry Ryumin on 06/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRSearchedAirportsManager.h"

#define kSearchedAirportsStorageKey @"kSearchedAirportsStorageKey"
#define kSearchedAirportsMaxCount 20

@implementation JRSearchedAirportsManager

+ (void)markSearchedAirport:(id<JRSDKAirport>)searchedAirport {
    NSDictionary *airportData = @{
                                  @"iata": [searchedAirport iata],
                                  @"isCity": @([searchedAirport isCity])
                                  };
    
    NSMutableArray *searchedAirports = [[JRSearchedAirportsManager rawSearchedAirports] mutableCopy];
    
    for (NSDictionary *airportData in searchedAirports) {
        if ([airportData[@"iata"] isEqualToString:[searchedAirport iata]] && [airportData[@"isCity"] boolValue] == [searchedAirport isCity]) {
            [searchedAirports removeObject:airportData];
            break;
        }
    }
    
    [searchedAirports insertObject:airportData atIndex:0];
    
    if ([searchedAirports count] > kSearchedAirportsMaxCount) {
        [searchedAirports removeObjectsInRange:NSMakeRange(kSearchedAirportsMaxCount, [searchedAirports count] - kSearchedAirportsMaxCount)];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:searchedAirports forKey:kSearchedAirportsStorageKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray<id<JRSDKAirport>> *)searchedAirports {
    NSMutableArray *airports = [NSMutableArray array];
    
    for (NSDictionary *airportData in [JRSearchedAirportsManager rawSearchedAirports]) {
        id<JRSDKAirport> airport = [[[AviasalesSDK sharedInstance] airportsStorage] findAirportByIATA:airportData[@"iata"] city:[airportData[@"isCity"] boolValue]];
        if (airport) {
            [airports addObject:airport];
        }
    }
    
    return airports;
}

+ (NSArray *)rawSearchedAirports {
    id airportsData = [[NSUserDefaults standardUserDefaults] valueForKey:kSearchedAirportsStorageKey];
    NSArray *searchedAirports = [NSArray array];
    if ([airportsData isKindOfClass:[NSArray class]]) {
        searchedAirports = (NSArray *)airportsData;
    }
    
    return searchedAirports;
}

@end
