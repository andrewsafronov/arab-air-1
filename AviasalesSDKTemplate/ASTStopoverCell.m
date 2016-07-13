//
//  ASTStopoverCell.m
//  AviasalesSDKTemplate
//

#import "ASTStopoverCell.h"


@implementation ASTStopoverCell

- (void)applyFlight:(id<JRSDKFlight>)nextFlight {
    _duration.text = [AviasalesNumberUtil formatDuration:nextFlight.delay];
    _place.text = [NSString stringWithFormat:@"%@ %@", nextFlight.originAirport.city, nextFlight.originAirport.iata];
}

@end
