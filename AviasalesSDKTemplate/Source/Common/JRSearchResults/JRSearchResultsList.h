//
//  JRSearchResultsList.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTableManager.h"

@class JRSearchResultsFlightSegmentCellLayoutParameters;

@protocol JRSearchResultsListDelegate <NSObject>

- (NSArray<id<JRSDKTicket>> *)tickets;
- (void)didSelectTicketAtIndex:(NSInteger)index;

@end


@interface JRSearchResultsList : NSObject <JRTableManager>

@property (weak, nonatomic) id<JRSearchResultsListDelegate> delegate;
@property (strong, nonatomic, readonly) NSString *ticketCellNibName;
@property (strong, nonatomic) JRSearchResultsFlightSegmentCellLayoutParameters *flightSegmentLayoutParameters;

- (instancetype)initWithCellNibName:(NSString *)cellNibName;

@end
