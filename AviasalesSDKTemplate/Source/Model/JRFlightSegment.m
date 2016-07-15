//
//  JRFlightSegment.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFlightSegment.h"


@implementation JRFlightSegment

@synthesize segmentAirline;
@synthesize flights = _flights;
@synthesize totalDurationInMinutes;
@synthesize delayDurationInMinutes;
@synthesize hasOvernightStopover;
@synthesize hasTransferToAnotherAirport;
@synthesize departureDateTimestamp;
@synthesize arrivalDateTimestamp;

@end