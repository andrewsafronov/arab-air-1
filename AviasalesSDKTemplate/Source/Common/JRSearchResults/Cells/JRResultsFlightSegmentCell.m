//
//  JRResultsFlightSegmentCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <AviasalesSDK/AviasalesSDK.h>
#import "JRResultsFlightSegmentCell.h"
#import "DateUtil.h"
#import "JRSearchResultsFlightSegmentCellLayoutParameters.h"

static const CGFloat kCellHeight = 25;

static const CGFloat kSmallDepartureDateLeading = 15;
static const CGFloat kSmallFlightDurationTrailing = 9;

static const CGFloat kDepartureDateLeading = 21;
static const CGFloat kFlightDurationTrailing = 19;


@interface JRResultsFlightSegmentCell()

@property (weak, nonatomic) IBOutlet UILabel *departureDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *departureLabel;
@property (weak, nonatomic) IBOutlet UILabel *stopoverNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivingLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightDurationLabel;

//Constraints

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureDateWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrivalLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flightDurationWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flightDurationTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *departureDateLeading;

@end


@implementation JRResultsFlightSegmentCell

#pragma mark - Getters

+ (NSString *)nibFileName {
    return @"JRResultsFlightSegmentCell";
}

+ (CGFloat)height {
    return kCellHeight;
}

- (void)updateConstraints {
    if (self.bounds.size.width < 360) {
        self.departureDateLeading.constant = kSmallDepartureDateLeading;
        self.flightDurationTrailing.constant = kSmallFlightDurationTrailing;
    } else {
        self.departureDateLeading.constant = kDepartureDateLeading;
        self.flightDurationTrailing.constant = kFlightDurationTrailing;
    }
    [super updateConstraints];
}

#pragma mark - Setters

- (void)setFrame:(CGRect)frame {
    const BOOL needToUpdateConstraints = frame.size.width != self.frame.size.width;
    [super setFrame:frame];
    if (needToUpdateConstraints) {
        [self setNeedsUpdateConstraints];
    }
}

- (void)setFlightSegment:(id<JRSDKFlightSegment>)flightSegment {
    _flightSegment = flightSegment;

    id<JRSDKFlight> const firstFlight = flightSegment.flights.firstObject;
    id<JRSDKFlight> const lastFlight = flightSegment.flights.lastObject;

    self.departureDateLabel.text = [DateUtil dateToDateString:firstFlight.departureDate];
    NSString *const departureTime = [DateUtil dateToTimeString:firstFlight.departureDate];
    NSString *const arrivalTime = [DateUtil dateToTimeString:lastFlight.arrivalDate];
    JRSDKIATA const departureIATA = firstFlight.originAirport.iata;
    JRSDKIATA const arrivalIATA = lastFlight.destinationAirport.iata;

    self.departureLabel.text = [NSString stringWithFormat:@"%@ %@", departureTime, departureIATA];
    self.arrivingLabel.text = [NSString stringWithFormat:@"%@ %@", arrivalTime, arrivalIATA];

    const NSInteger flightsCount = flightSegment.flights.count;
    if (flightsCount == 1) {
        self.stopoverNumberLabel.hidden = YES;
    } else {
        self.stopoverNumberLabel.hidden = NO;
        self.stopoverNumberLabel.text = [NSString stringWithFormat:@"%i", (int)(flightsCount - 1)];
    }

    self.flightDurationLabel.text = [DateUtil duration:[flightSegment totalDurationInMinutes] durationStyle:JRDateUtilDurationShortStyle];
}

- (void)setLayoutParameters:(JRSearchResultsFlightSegmentCellLayoutParameters *)layoutParameters {
    _layoutParameters = layoutParameters;
    self.departureDateWidth.constant = self.layoutParameters.departureDateWidth;
    self.departureLabelWidth.constant = self.layoutParameters.departureLabelWidth;
    self.arrivalLabelWidth.constant = self.layoutParameters.arrivalLabelWidth;
    self.flightDurationWidth.constant = self.layoutParameters.flightDurationWidth;
}
@end
