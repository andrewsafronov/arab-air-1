//
//  JRFilterTask.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterTicketBounds.h"


@protocol JRFilterTaskDelegate<NSObject>

@required
- (void)filterTaskDidFinishWithTickets:(NSOrderedSet<id<JRSDKTicket>> *)filteredTickets;

@end


@interface JRFilterTask : NSObject

+ (instancetype)filterTaskForTickets:(NSOrderedSet<id<JRSDKTicket>> *)ticketsToFilter
                        ticketBounds:(JRFilterTicketBounds *)ticketBounds
                 travelSegmentBounds:(NSArray *)travelSegmentBounds
                        taskDelegate:(id<JRFilterTaskDelegate>)delegate;

- (void)performFiltering;

@end
