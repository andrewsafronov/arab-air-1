//
//  JRFilterItemsFactory.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>
#include "JRFilterItemProtocol.h"

@class JRFilter;
@class JRFilterItem;


@interface JRFilterItemsFactory : NSObject

- (instancetype)initWithFilter:(JRFilter *)filter;

- (NSArray *)createSectionsForSimpleMode;
- (NSArray *)createSectionsForComplexMode;
- (NSArray *)createSectionsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

@end
