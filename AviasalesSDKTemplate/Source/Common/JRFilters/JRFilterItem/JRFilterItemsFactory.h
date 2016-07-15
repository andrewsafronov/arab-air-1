//
//  JRFilterItemsFactory.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 23/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>


@class JRFilter;
@class JRFilterItem;


@interface JRFilterItemsFactory : NSObject

- (instancetype)initWithFilter:(JRFilter *)filter;

- (NSArray *)createSectionsForSimpleMode;
- (NSArray *)createSectionsForComplexMode;
- (NSArray *)createSectionsForTravelSegment:(id<JRSDKTravelSegment>)travelSegment;

@end
