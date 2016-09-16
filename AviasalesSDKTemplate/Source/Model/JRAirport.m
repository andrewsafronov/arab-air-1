//
//  JRAirport.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRAirport.h"


@implementation JRAirport

@synthesize averageRate;
@synthesize city;
@synthesize cityNameCasePr;
@synthesize cityNameCaseRo;
@synthesize cityNameCaseVi;
@synthesize country;
@synthesize iata;
@synthesize parentIata;
@synthesize latitude;
@synthesize longitude;
@synthesize airportName;
@synthesize numberOfSearches;
@synthesize airportType;
@synthesize isCity;
@synthesize indexStrings;
@synthesize fromServer;
@synthesize timeZone;

- (NSArray *)coordinates {
    if ([self.latitude doubleValue] != 0 && [self.longitude doubleValue] != 0) {
        return @[self.latitude, self.longitude];
    } else {
        return nil;
    }
}

- (CLLocationCoordinate2D)CLLCoordinate {
    CLLocationCoordinate2D result;
    NSArray *coordinates = self.coordinates;
    if (coordinates) {
        result.longitude = [(self.coordinates)[1] doubleValue];
        result.latitude  = [[self.coordinates firstObject] doubleValue];
    } else {
        result.longitude = 0;
        result.latitude = 0;
    }
    return result;
}
@end

