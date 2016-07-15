//
//  JRTransferCell.m
//  AviasalesSDKTemplate
//

#import "JRTransferCell.h"
#import "DateUtil.h"

@implementation JRTransferCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.verticalDivider.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.verticalDivider.layer.shadowRadius = 2.0;
    self.verticalDivider.layer.shadowOpacity = 0.3;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.separatorInset = UIEdgeInsetsMake(0.0, self.bounds.size.width, 0.0, 0.0);
}

#pragma mark JRTicketCellProtocol methods

- (void)applyFlight:(id<JRSDKFlight>)nextFlight {
    NSString *delayString = [DateUtil formatDurationInMinutes:nextFlight.delay.integerValue toHourAndMinutesStringWithFormat:AVIASALES_(@"AVIASALES_DURATION_FORMAT")];
    self.durationLabel.text = [NSString stringWithFormat:@"%@: %@", AVIASALES_(@"AVIASALES_STOPOVER"), delayString];
    self.placeLabel.text = [NSString stringWithFormat:@"%@ %@", nextFlight.originAirport.city, nextFlight.originAirport.iata];
}

@end
