//
//  JRFlightsSegmentHeaderView.h
//  AviasalesSDKTemplate
//
//  Created by Oleg on 08/06/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRFlightsSegmentHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) id<JRSDKFlightSegment> flightSegment;

@end
