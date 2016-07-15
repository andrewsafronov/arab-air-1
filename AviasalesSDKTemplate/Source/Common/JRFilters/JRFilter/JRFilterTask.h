//
//  JRFilterTask.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
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
