//
//  JRSearchResult.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//


#import <Foundation/Foundation.h>
#import "JRTicket.h"

@interface JRSearchResult : NSObject <JRSDKSearchResult>
@property (nonatomic, retain) NSOrderedSet <JRTicket *> *searchTickets;
@property (nonatomic, retain) NSOrderedSet <JRTicket *> *strictSearchTickets;
@end
