//
//  JRAirportPickerCellWithAirport.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/01/14.
//
//

#import <UIKit/UIKit.h>
#import "JRAirport.h"
#import "JRTableViewCell.h"

@interface JRAirportPickerCellWithAirport : JRTableViewCell

@property (strong, nonatomic) id<JRSDKAirport> airport;
@property (strong, nonatomic) NSString *searchString;
@end
