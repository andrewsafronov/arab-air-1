//
//  JRTransferCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTransferCell.h"
#import "DateUtil.h"

@implementation JRTransferCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.separatorInset = UIEdgeInsetsMake(0.0, self.bounds.size.width, 0.0, 0.0);
}

#pragma mark JRTicketCellProtocol methods

- (void)applyFlight:(id<JRSDKFlight>)nextFlight {
    NSString *delayString = [DateUtil duration:nextFlight.delay.integerValue durationStyle:JRDateUtilDurationShortStyle];
    self.durationLabel.text = [NSString stringWithFormat:@"%@: %@", AVIASALES_(@"JR_TICKET_TRANSFER"), delayString];
    self.placeLabel.text = [NSString stringWithFormat:@"%@ %@", nextFlight.originAirport.city, nextFlight.originAirport.iata];
}

@end
