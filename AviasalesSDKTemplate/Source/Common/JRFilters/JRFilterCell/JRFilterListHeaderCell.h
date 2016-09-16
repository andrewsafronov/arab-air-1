//
//  JRFilterListHeaderCell.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>
#import "JRFilterListHeaderItem.h"
#import "JRTableViewCell.h"

@interface JRFilterListHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIImageView *openIndicator;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (strong, nonatomic) JRFilterListHeaderItem *item;

@property (nonatomic, assign) BOOL expanded;

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;

@end
