//
//  JRFilterListHeaderCell.h
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import <UIKit/UIKit.h>
#import "JRFilterListHeaderItem.h"
#import "JRTableViewCell.h"

@interface JRFilterListHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIImageView *openIndicator;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (strong, nonatomic) JRFilterListHeaderItem *item;

@property (nonatomic, assign) BOOL expand;

@end
