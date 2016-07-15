//
//  JRFilterTravelSegmentItem.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterTravelSegmentItem.h"

#import "DateUtil.h"


@interface JRFilterTravelSegmentItem ()

@end


@implementation JRFilterTravelSegmentItem

- (instancetype)initWithTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    self = [super init];
    if (self) {
        _travelSegment = travelSegment;
    }
    
    return self;
}

#pragma - mark JRFilterItemProtocol

- (NSString *)tilte {
    return [NSString stringWithFormat:@"%@ – %@", self.travelSegment.originAirport.iata, self.travelSegment.destinationAirport.iata];
}

- (NSString *)detailsTitle {
    return [DateUtil fullDayMonthYearWeekdayStringFromDate:self.travelSegment.departureDate];
}

- (NSAttributedString *)attributedStringValue {
    return [[NSAttributedString alloc] initWithString:@""];
}

@end
