//
//  JRAirportPickerCellWithAirport.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>
#import "JRAirport.h"
#import "JRTableViewCell.h"

@interface JRAirportPickerCellWithAirport : JRTableViewCell

@property (strong, nonatomic) id<JRSDKAirport> airport;
@property (strong, nonatomic) NSString *searchString;

@end
