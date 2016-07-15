//
//  JRFilterTravelSegmentBounds.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 30/03/14.
//
//

#import <Foundation/Foundation.h>

@interface JRFilterTravelSegmentBounds : NSObject

@property (strong, nonatomic) id<JRSDKTravelSegment> travelSegment;

@property (assign, nonatomic) BOOL transferToAnotherAirport;
@property (assign, nonatomic) BOOL filterTransferToAnotherAirport;

@property (assign, nonatomic) BOOL overnightStopover;
@property (assign, nonatomic) BOOL filterOvernightStopover;

@property (assign, nonatomic) NSTimeInterval maxDepartureTime;
@property (assign, nonatomic) NSTimeInterval minDepartureTime;
@property (assign, nonatomic) NSTimeInterval minFilterDepartureTime;
@property (assign, nonatomic) NSTimeInterval maxFilterDepartureTime;

@property (assign, nonatomic) NSTimeInterval maxArrivalTime;
@property (assign, nonatomic) NSTimeInterval minArrivalTime;
@property (assign, nonatomic) NSTimeInterval minFilterArrivalTime;
@property (assign, nonatomic) NSTimeInterval maxFilterArrivalTime;

@property (assign, nonatomic) JRSDKFlightDuration maxDelaysDuration;
@property (assign, nonatomic) JRSDKFlightDuration minDelaysDuration;
@property (assign, nonatomic) JRSDKFlightDuration minFilterDelaysDuration;
@property (assign, nonatomic) JRSDKFlightDuration maxFilterDelaysDuration;

@property (assign, nonatomic) JRSDKFlightDuration maxTotalDuration;
@property (assign, nonatomic) JRSDKFlightDuration minTotalDuration;
@property (assign, nonatomic) JRSDKFlightDuration filterTotalDuration;

@property (strong, nonatomic) NSOrderedSet<NSNumber *> *transfersCounts;
@property (strong, nonatomic) NSOrderedSet<NSNumber *> *filterTransfersCounts;

@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirline>> *airlines;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirline>> *filterAirlines;

@property (strong, nonatomic) NSOrderedSet<id<JRSDKAlliance>> *alliances;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKAlliance>> *filterAlliances;

@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirport>> *originAirports;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirport>> *filterOriginAirports;

@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirport>> *stopoverAirports;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirport>> *filterStopoverAirports;

@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirport>> *destinationAirports;
@property (strong, nonatomic) NSOrderedSet<id<JRSDKAirport>> *filterDestinationAirports;

@property (strong, nonatomic, readonly) NSOrderedSet<NSNumber *> *minPriceForTransfersCounts;

@property (assign, nonatomic, readonly) BOOL isReseted;


- (instancetype)initWithTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

- (void)resetBounds;

@end
