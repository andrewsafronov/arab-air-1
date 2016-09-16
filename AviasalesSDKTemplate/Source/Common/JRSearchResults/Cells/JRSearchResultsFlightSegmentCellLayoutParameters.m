//
//  JRSearchResultsFlightSegmentCellLayoutParameters.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchResultsFlightSegmentCellLayoutParameters.h"
#import "JRStringsWidthComputer.h"
#import "DateUtil.h"

@implementation JRSearchResultsFlightSegmentCellLayoutParameters
@synthesize departureDateWidth = _departureDateWidth;
@synthesize departureLabelWidth = _departureLabelWidth;
@synthesize arrivalLabelWidth = _arrivalLabelWidth;
@synthesize flightDurationWidth = _flightDurationWidth;

- (instancetype)initWithDepartureDateWidth:(CGFloat)departureDateWidth
                       departureLabelWidth:(CGFloat)departureLabelWidth
                         arrivalLabelWidth:(CGFloat)arrivalLabelWidth
                       flightDurationWidth:(CGFloat)flightDurationWidth {
    if (self = [super init]) {
        _departureDateWidth = departureDateWidth;
        _departureLabelWidth = departureLabelWidth;
        _arrivalLabelWidth = arrivalLabelWidth;
        _flightDurationWidth = flightDurationWidth;
    }
    return self;
}

+ (instancetype)parametersWithTickets:(NSArray<id<JRSDKTicket>> *)tickets
                                 font:(UIFont *)font {
    CGFloat departureDateWidth = 0;
    CGFloat departureLabelWidth = 0;
    CGFloat arrivalLabelWidth = 0;
    CGFloat flightDurationWidth = 0;

    JRStringsWidthComputer *const computer = [[JRStringsWidthComputer alloc] initWithFont:font];

    for (id<JRSDKTicket> ticket in tickets) {
        for (id<JRSDKFlightSegment> flightSegment in ticket.flightSegments) {
            id<JRSDKFlight> const firstFlight = flightSegment.flights.firstObject;
            id<JRSDKFlight> const lastFlight = flightSegment.flights.lastObject;

            NSString *const departureDate = [DateUtil dateToDateString:firstFlight.departureDate];
            NSString *const departureTime = [DateUtil dateToTimeString:firstFlight.departureDate];
            NSString *const arrivalTime = [DateUtil dateToTimeString:lastFlight.arrivalDate];

            JRSDKIATA const departureIATA = firstFlight.originAirport.iata;
            JRSDKIATA const arrivalIATA = lastFlight.destinationAirport.iata;

            NSString *const departureLabel = [NSString stringWithFormat:@"%@ %@", departureTime, departureIATA];
            NSString *const arrivalLabel = [NSString stringWithFormat:@"%@ %@", arrivalTime, arrivalIATA];

            NSString *const flightDuration = [DateUtil duration:[flightSegment totalDurationInMinutes] durationStyle:JRDateUtilDurationShortStyle];

            departureDateWidth = MAX(departureDateWidth, [computer widthWithString:departureDate]);
            departureLabelWidth = MAX(departureLabelWidth, [computer widthWithString:departureLabel]);
            arrivalLabelWidth = MAX(arrivalLabelWidth, [computer widthWithString:arrivalLabel]);
            flightDurationWidth = MAX(flightDurationWidth, [computer widthWithString:flightDuration]);
        }
    }
    
    return [[JRSearchResultsFlightSegmentCellLayoutParameters alloc] initWithDepartureDateWidth:ceil(departureDateWidth)
                                                                            departureLabelWidth:ceil(departureLabelWidth)
                                                                              arrivalLabelWidth:ceil(arrivalLabelWidth)
                                                                            flightDurationWidth:ceil(flightDurationWidth)];
}
@end
