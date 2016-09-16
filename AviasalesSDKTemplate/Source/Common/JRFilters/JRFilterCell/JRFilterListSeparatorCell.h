//
//  JRFilterListSeparatorCell.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>
#import "JRTableViewCell.h"

@class JRFilterListSeparatorItem;

@interface JRFilterListSeparatorCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *separatorLabel;

@property (strong, nonatomic) JRFilterListSeparatorItem *item;

@end
