//
//  ASTResultsFlightSegmentCell.m
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 26.05.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <AviasalesSDK/AviasalesSDK.h>
#import "ASTResultsFlightSegmentCell.h"
#import "DateUtil.h"

static const CGFloat kCellHeight = 25;

@interface ASTResultsFlightSegmentCell()

@property (weak, nonatomic) IBOutlet UILabel *departureDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopoverNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivingLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightDurationLabel;

@end

@implementation ASTResultsFlightSegmentCell

#pragma mark - Getters

+ (NSString *)nibFileName {
    return @"ASTResultsFlightSegmentCell";
}

+ (CGFloat)height {
    return kCellHeight;
}

#pragma mark - Setters

- (void)setFlightSegment:(id<JRSDKFlightSegment>)flightSegment {
    _flightSegment = flightSegment;

    static NSDateFormatter *dateFormatter = nil;
    static NSDateFormatter *timeFormatter = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSTimeZone *GMT = [NSTimeZone timeZoneForSecondsFromGMT:0];

        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMM"];
        [dateFormatter setTimeZone:GMT];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:AVIASALES__(@"AVIASALES_LANG", [NSLocale currentLocale].localeIdentifier)]];

        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateFormat:@"HH:mm"];
        [timeFormatter setTimeZone:GMT];
        [timeFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    });

    id<JRSDKFlight> const firstFlight = flightSegment.flights.firstObject;
    id<JRSDKFlight> const lastFlight = flightSegment.flights.lastObject;

    self.departureDateLabel.text = [dateFormatter stringFromDate:firstFlight.departureDate];
    NSString *const departureTime = [timeFormatter stringFromDate:firstFlight.departureDate];
    NSString *const arrivalTime = [timeFormatter stringFromDate:lastFlight.arrivalDate];
    JRSDKIATA const departureIATA = firstFlight.originAirport.iata;
    JRSDKIATA const arrivalIATA = lastFlight.destinationAirport.iata;

    self.departureLabel.text = [NSString stringWithFormat:@"%@ %@", departureTime, departureIATA];
    self.arrivingLabel.text = [NSString stringWithFormat:@"%@ %@", arrivalTime, arrivalIATA];

    self.stopoverNumberLabel.text = [NSString stringWithFormat:@"%i", (int)flightSegment.flights.count];

    self.flightDurationLabel.text = [DateUtil formatDurationInMinutes:[flightSegment totalDurationInMinutes] toHourAndMinutesStringWithFormat:AVIASALES_(@"AVIASALES_DURATION_FORMAT")];
}

@end
