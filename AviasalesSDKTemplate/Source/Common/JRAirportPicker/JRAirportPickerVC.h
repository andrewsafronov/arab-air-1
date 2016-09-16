//
//  JRAirportPickerVC.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTravelSegment.h"
#import "JRViewController.h"

typedef enum {
	JRAirportPickerOriginMode,
	JRAirportPickerDestinationMode
} JRAirportPickerMode;

@interface JRAirportPickerVC : JRViewController

- (instancetype)initWithMode:(JRAirportPickerMode)mode travelSegment:(JRTravelSegment *)travelSegment;

@end
