//
//  ASTResultsFlightSegmentCell.h
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 26.05.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JRSDKFlightSegment;

@interface ASTResultsFlightSegmentCell : UITableViewCell
@property (strong, nonatomic) id<JRSDKFlightSegment> flightSegment;
+ (NSString *)nibFileName;
+ (CGFloat)height;
@end
