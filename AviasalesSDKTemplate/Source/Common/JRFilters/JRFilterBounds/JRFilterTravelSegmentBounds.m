//
//  JRFilterTravelSegmentBounds.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 30/03/14.
//
//

#import "JRFilterTravelSegmentBounds.h"

#import "JRFilter.h"


@interface JRFilterTravelSegmentBounds ()

@end


@implementation JRFilterTravelSegmentBounds

- (instancetype)initWithTravelSegment:(id<JRSDKTravelSegment>)travelSegment {
    self = [super init];
    if (self) {
        _travelSegment = travelSegment;
        
        _transferToAnotherAirport = NO;
        _overnightStopover = NO;
        
        _maxDepartureTime = 0.0;
        _minDepartureTime = CGFLOAT_MAX;
        
        _maxArrivalTime = 0.0;
        _minArrivalTime = CGFLOAT_MAX;
        
        _maxDelaysDuration = 0.0;
        _minDelaysDuration = NSIntegerMax;
        
        _maxTotalDuration = 0.0;
        _minTotalDuration = NSIntegerMax;
        
        _transfersCounts = [NSOrderedSet orderedSet];
        
        _airlines = [NSOrderedSet orderedSet];
        _alliances = [NSOrderedSet orderedSet];
        
        _originAirports = [NSOrderedSet orderedSet];
        _stopoverAirports = [NSOrderedSet orderedSet];
        _destinationAirports = [NSOrderedSet orderedSet];
        
        [self resetBounds];
    }
    return self;
}

- (void)resetBounds {
    _filterTransferToAnotherAirport = _transferToAnotherAirport;
    _filterOvernightStopover = _overnightStopover;
    
    _filterTotalDuration = _maxTotalDuration;
    
    _minFilterDelaysDuration = _minDelaysDuration;
    _maxFilterDelaysDuration = _maxDelaysDuration;
    
    _minFilterDepartureTime = _minDepartureTime;
    _maxFilterDepartureTime = _maxDepartureTime;
    
    _minFilterArrivalTime = _minArrivalTime;
    _maxFilterArrivalTime = _maxArrivalTime;
    
    _filterTransfersCounts = [_transfersCounts copy];
    
    _filterAlliances = [_alliances copy];
    _filterAirlines = [_airlines copy];
    
    _filterOriginAirports = [_originAirports copy];
    _filterStopoverAirports = [_stopoverAirports copy];
    _filterDestinationAirports = [_destinationAirports copy];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidResetNotificationName object:self];
}

- (BOOL)isReseted {
    BOOL isReseted = !self.filterOvernightStopover && !self.filterOvernightStopover &&
    
    self.filterTotalDuration == self.maxTotalDuration &&
    
    self.minFilterDepartureTime == self.minDepartureTime &&
    self.maxFilterDepartureTime == self.maxDepartureTime &&
    
    self.minFilterDepartureTime == self.minDepartureTime &&
    self.maxFilterDepartureTime == self.maxDepartureTime &&
    
    self.minFilterArrivalTime == self.minArrivalTime &&
    self.maxFilterArrivalTime == self.maxArrivalTime &&
    
    self.filterAlliances.count == 0 &&
    self.filterAirlines.count == 0 &&
    
    self.filterOriginAirports.count == 0 &&
    self.filterStopoverAirports.count == 0 &&
    self.filterDestinationAirports.count == 0;
    
    return isReseted;
}

- (void)setFilterOvernightStopover:(BOOL)filterOvernightStopover {
    if (_filterOvernightStopover != filterOvernightStopover) {
        _filterOvernightStopover = filterOvernightStopover;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterTransferToAnotherAirport:(BOOL)filterTransferToAnotherAirport {
    if (_filterTransferToAnotherAirport != filterTransferToAnotherAirport) {
        _filterTransferToAnotherAirport = filterTransferToAnotherAirport;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterTotalDuration:(JRSDKFlightDuration)filterTotalDuration {
    if (_filterTotalDuration != filterTotalDuration) {
        _filterTotalDuration = filterTotalDuration;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setMinFilterDepartureTime:(NSTimeInterval)minFilterDepartureTime {
    if (_minFilterDepartureTime != minFilterDepartureTime) {
        _minFilterDepartureTime = minFilterDepartureTime;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setMaxFilterDepartureTime:(NSTimeInterval)maxFilterDepartureTime {
    if (_maxFilterDepartureTime != maxFilterDepartureTime) {
        _maxFilterDepartureTime = maxFilterDepartureTime;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setMinFilterArrivalTime:(NSTimeInterval)minFilterArrivalTime {
    if (_minFilterArrivalTime != minFilterArrivalTime) {
        _minFilterArrivalTime = minFilterArrivalTime;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setMaxFilterArrivalTime:(NSTimeInterval)maxFilterArrivalTime {
    if (_maxFilterArrivalTime != maxFilterArrivalTime) {
        _maxFilterArrivalTime = maxFilterArrivalTime;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setMinFilterDelaysDuration:(JRSDKFlightDuration)minFilterDelaysDuration {
    if (_minFilterDelaysDuration != minFilterDelaysDuration) {
        _minFilterDelaysDuration = minFilterDelaysDuration;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setMaxFilterDelaysDuration:(JRSDKFlightDuration)maxFilterDelaysDuration {
    if (_maxFilterDelaysDuration != maxFilterDelaysDuration) {
        _maxFilterDelaysDuration = maxFilterDelaysDuration;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterTransfersCounts:(NSOrderedSet<NSNumber *> *)filterTransfersCounts {
    if (![_filterTransfersCounts.set isEqualToSet:filterTransfersCounts.set]) {
        _filterTransfersCounts = filterTransfersCounts;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterAirlines:(NSOrderedSet<id<JRSDKAirline>> *)filterAirlines {
    if (![_filterAirlines.set isEqualToSet:filterAirlines.set]) {
        _filterAirlines = filterAirlines;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterAlliances:(NSOrderedSet<id<JRSDKAlliance>> *)filterAlliances {
    if (![_filterAlliances.set isEqualToSet:filterAlliances.set]) {
        _filterAlliances = filterAlliances;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterOriginAirports:(NSOrderedSet<id<JRSDKAirport>> *)filterOriginAirports {
    if (![_filterOriginAirports.set isEqualToSet:filterOriginAirports.set]) {
        _filterOriginAirports = filterOriginAirports;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterStopoverAirports:(NSOrderedSet<id<JRSDKAirport>> *)filterStopoverAirports {
    if (![_filterStopoverAirports.set isEqualToSet:filterStopoverAirports.set]) {
        _filterStopoverAirports = filterStopoverAirports;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

- (void)setFilterDestinationAirports:(NSOrderedSet<id<JRSDKAirport>> *)filterDestinationAirports {
    if (![_filterDestinationAirports.set isEqualToSet:filterDestinationAirports.set]) {
        _filterDestinationAirports = filterDestinationAirports;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kJRFilterBoundsDidChangeNotificationName object:self];
    }
}

@end
