//
//  JRTicket.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTicket.h"


@implementation JRTicket

@synthesize flightSegments;
@synthesize prices = _prices;
@synthesize mainAirline;
@synthesize simpleRating;
@synthesize totalDuration;
@synthesize delayDuration;
@synthesize hasOvernightStopover;
@synthesize sign;
@synthesize isFromTrustedGate;
@synthesize priceBeforeMagic;

@end