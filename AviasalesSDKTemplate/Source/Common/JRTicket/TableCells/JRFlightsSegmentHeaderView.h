//
//  JRFlightsSegmentHeaderView.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>

@interface JRFlightsSegmentHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) id<JRSDKFlightSegment> flightSegment;

@end
