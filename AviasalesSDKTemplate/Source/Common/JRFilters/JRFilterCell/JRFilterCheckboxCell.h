//
//  JRFilterListCell.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRTableViewCell.h"

@class JRAverageRateView;
@class JRFilterCheckBoxItem;

@interface JRFilterCheckboxCell : UITableViewCell

@property (strong, nonatomic) JRAverageRateView *averageRateView;

@property (weak, nonatomic) IBOutlet UIButton *selectedIndicator;
@property (weak, nonatomic) IBOutlet UILabel *listItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *listItemDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *averageRateViewContainer;

@property (nonatomic, strong) JRFilterCheckBoxItem *item;

@property (nonatomic, assign) BOOL checked;

@end
