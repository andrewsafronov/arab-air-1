//
//  JRFilterVC.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
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
