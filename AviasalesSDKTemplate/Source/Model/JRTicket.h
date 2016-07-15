//
//  JRTicket.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>
#import "JRFlightSegment.h"
#import "JRPrice.h"
#import "JRAirline.h"

@class JRSearchInfo;

@interface JRTicket : NSObject <JRSDKTicket>

@property (nonatomic, strong) NSOrderedSet <JRFlightSegment *> *flightSegments;
@property (nonatomic, strong) NSSet <JRPrice *> *unorderedPrices;
@property (nonatomic, strong) JRAirline *mainAirline;
@property (nonatomic, weak) JRSearchInfo *searchInfo;

@end