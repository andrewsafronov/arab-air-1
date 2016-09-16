//
//  JRResultsTicketCell.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>

@protocol JRSDKTicket;
@class JRSearchResultsFlightSegmentCellLayoutParameters;

@interface JRResultsTicketCell : UITableViewCell

@property (strong, nonatomic) id<JRSDKTicket> ticket;
@property (strong, nonatomic) JRSearchResultsFlightSegmentCellLayoutParameters *flightSegmentsLayoutParameters;

+ (NSString *)nibFileName;
+ (CGFloat)heightWithTicket:(id<JRSDKTicket>)ticket;

@end
