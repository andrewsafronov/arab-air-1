//
//  JRFilterCheckboxCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterCheckboxCell.h"

#import "JRFilterCheckBoxItem.h"
#import "JRColorScheme.h"
#import <AXRatingView/AXRatingView.h>


static const CGFloat kCellInnerPaddings = 100.0;

@implementation JRFilterCheckboxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0.0, 44.0, 0.0, 0.0);
    
    self.listItemLabel.numberOfLines = 3;
    self.listItemDetailLabel.textColor = [JRColorScheme darkTextColor];
    
    self.averageRateView = [[AXRatingView alloc] init];
    self.averageRateView.markFont = [UIFont systemFontOfSize:15];
    self.averageRateView.baseColor = [JRColorScheme ratingStarDefaultColor];
    self.averageRateView.highlightColor = [JRColorScheme ratingStarSelectedColor];
    self.averageRateView.numberOfStar = 5;
    self.averageRateView.userInteractionEnabled = NO;
    self.averageRateView.frame = self.averageRateViewContainer.bounds;
    [self.averageRateViewContainer addSubview:self.averageRateView];
    self.averageRateViewContainer.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (iOSVersionLessThan(@"8.0")) {
        self.listItemLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - CGRectGetWidth(self.averageRateView.frame) - kCellInnerPaddings;
    }
}

#pragma - mark Public methds

- (void)setItem:(JRFilterCheckBoxItem *)item {
    _item = item;
    _checked = item.selected;
    
    self.averageRateView.hidden = !item.showAverageRate;
    self.averageRateView.value = item.rating;
    self.listItemLabel.text = item.tilte;
    self.listItemDetailLabel.attributedText = item.attributedStringValue;
    self.selectedIndicator.selected = item.selected;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    
    self.selectedIndicator.selected = checked;
    
    self.item.selected = checked;
    self.item.filterAction();
}

@end
