//
//  JRFilterTravelSegmentCell.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTableViewCell.h"

@class JRFilterTravelSegmentItem;


@interface JRFilterTravelSegmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *flightDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *deparureDateLabel;

@property (strong, nonatomic) JRFilterTravelSegmentItem *item;

@end
