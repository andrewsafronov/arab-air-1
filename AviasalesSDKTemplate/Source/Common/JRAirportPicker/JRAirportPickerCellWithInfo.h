//
//  JRAirportPickerCellWithInformation.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 30/01/14.
//
//

#import <UIKit/UIKit.h>
#import "JRTableViewCell.h"

@interface JRAirportPickerCellWithInfo : JRTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *locationInfoLabel;

- (void)startActivityIndicator;
- (void)stopActivityIndicator;

@end

