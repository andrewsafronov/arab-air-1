//
//  JRTravelSegment.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>


@class JRSearchInfo;


@interface JRTravelSegment : NSObject <JRSDKTravelSegment>

@property (nonatomic, weak) JRSearchInfo *searchInfo;

- (BOOL)isValidSegment;

#pragma mark - Copying

- (JRTravelSegment *)copy;

@end