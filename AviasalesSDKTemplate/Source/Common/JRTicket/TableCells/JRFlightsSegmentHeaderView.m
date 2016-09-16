//
//  JRFlightsSegmentHeaderView.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFlightsSegmentHeaderView.h"
#import "DateUtil.h"

@interface JRFlightsSegmentHeaderView ()

@property (nonatomic, weak) IBOutlet UILabel* directionLabel;
@property (nonatomic, weak) IBOutlet UILabel* durationLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *separatorLineHeightConstraint;

@end

@implementation JRFlightsSegmentHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorLineHeightConstraint.constant = 1.0 / [UIScreen mainScreen].scale;
    
    [self updateContent];
}

#pragma mark Public methods

- (void)setFlightSegment:(id<JRSDKFlightSegment>)flightSegment {
    _flightSegment = flightSegment;
    
    [self updateContent];
}

#pragma mark Private methods

- (void)updateContent {
    if (self.flightSegment == nil) { return; }
    
    NSMutableArray *const airports = [NSMutableArray arrayWithCapacity:self.flightSegment.flights.count];
    [airports addObject:self.flightSegment.flights.firstObject.originAirport.iata];
    
    for (id<JRSDKFlight> flight in self.flightSegment.flights) {
        [airports addObject:flight.destinationAirport.iata];
    }
    
    self.directionLabel.text = [airports componentsJoinedByString:@" • "];
    self.durationLabel.text = [DateUtil duration:self.flightSegment.totalDurationInMinutes durationStyle:JRDateUtilDurationShortStyle];
}

@end
