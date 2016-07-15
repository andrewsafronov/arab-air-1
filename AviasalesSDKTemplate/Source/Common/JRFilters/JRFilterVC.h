//
//  JRFilterVC.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 30/03/14.
//
//

#import "JRViewController.h"

typedef NS_ENUM (NSUInteger, JRFilterMode) {
    JRFilterComplexMode         = 0,
    JRFilterSimpleSearchMode    = 1,
    JRFilterTravelSegmentMode   = 2
};


@class JRFilter;


@interface JRFilterVC : JRViewController

- (instancetype)initWithFilter:(JRFilter *)filter
                 forFilterMode:(JRFilterMode)filterMode
         selectedTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

@end
