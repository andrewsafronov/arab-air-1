//
//  JRAirportPickerVC.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 28/01/14.
//
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
