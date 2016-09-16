//
//  JRResultsFlightSegmentCell.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>

@protocol JRSDKFlightSegment;
@class JRSearchResultsFlightSegmentCellLayoutParameters;

@interface JRResultsFlightSegmentCell : UITableViewCell

@property (strong, nonatomic) id<JRSDKFlightSegment> flightSegment;
@property (strong, nonatomic) JRSearchResultsFlightSegmentCellLayoutParameters *layoutParameters;

+ (NSString *)nibFileName;
+ (CGFloat)height;

@end
