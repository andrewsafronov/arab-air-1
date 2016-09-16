//
//  JRTicket.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTicket.h"

@implementation JRTicket

@synthesize flightSegments;
@synthesize mainAirline;
@synthesize simpleRating;
@synthesize totalDuration;
@synthesize delayDuration;
@synthesize hasOvernightStopover;
@synthesize sign;
@synthesize isFromTrustedGate;

+ (JRTicket *)ticketByCopyingFieldsFromTicket:(id<JRSDKTicket>)ticket {
    JRTicket *newTicket = [JRTicket new];
    newTicket->flightSegments = [ticket.flightSegments copy];
    newTicket->mainAirline = ticket.mainAirline;
    newTicket->simpleRating = ticket.simpleRating;
    newTicket->totalDuration = ticket.totalDuration;
    newTicket->delayDuration = ticket.delayDuration;
    newTicket->hasOvernightStopover = ticket.hasOvernightStopover;
    newTicket->sign = ticket.sign;
    newTicket->isFromTrustedGate = ticket.isFromTrustedGate;
    newTicket->_prices = [ticket.prices copy];
    newTicket->_searchInfo = ticket.searchInfo;
    
    return newTicket;
}

- (BOOL)isEqual:(id)object {
    return [JRSDKModelUtils isTicket:self theSameAs:object];
}

- (NSUInteger)hash {
    return [self.sign hash];
}

@end
