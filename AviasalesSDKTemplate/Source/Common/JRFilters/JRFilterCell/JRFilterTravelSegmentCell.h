//
//  JRFilterTravelSegmentCell.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRTableViewCell.h"

@class JRFilterTravelSegmentItem;


@interface JRFilterTravelSegmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *flightDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *deparureDateLabel;

@property (strong, nonatomic) JRFilterTravelSegmentItem *item;

@end
