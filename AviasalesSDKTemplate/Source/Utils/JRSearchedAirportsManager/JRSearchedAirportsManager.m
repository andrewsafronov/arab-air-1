//
//  JRSearchedAirportsManager.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchedAirportsManager.h"

static NSString * const kJRSearchedAirportsStorageKey = @"kJRSearchedAirportsStorageKey";
static NSInteger const kJRSearchedAirportsMaxCount = 20;

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
    
    if ([searchedAirports count] > kJRSearchedAirportsMaxCount) {
        [searchedAirports removeObjectsInRange:NSMakeRange(kJRSearchedAirportsMaxCount, [searchedAirports count] - kJRSearchedAirportsMaxCount)];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:searchedAirports forKey:kJRSearchedAirportsStorageKey];
    
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
    id airportsData = [[NSUserDefaults standardUserDefaults] valueForKey:kJRSearchedAirportsStorageKey];
    NSArray *searchedAirports = [NSArray array];
    if ([airportsData isKindOfClass:[NSArray class]]) {
        searchedAirports = (NSArray *)airportsData;
    }
    
    return searchedAirports;
}

@end
