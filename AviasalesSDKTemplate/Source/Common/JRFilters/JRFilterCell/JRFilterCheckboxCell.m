//
//  JRFilterCheckboxCell.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterCheckboxCell.h"

#import "JRFilterCheckBoxItem.h"
#import "JRAverageRateView.h"
#import "ColorScheme.h"


static const CGFloat kCellInnerPaddings = 100.0;


@interface JRFilterCheckboxCell ()

@end


@implementation JRFilterCheckboxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0.0, 44.0, 0.0, 0.0);
    
    self.listItemLabel.numberOfLines = 3;
    self.listItemDetailLabel.textColor = [ColorScheme darkTextColor];
    
    self.averageRateView = LOAD_VIEW_FROM_NIB_NAMED(@"JRAverageRateView");
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
    
    self.averageRateView.hidden = item.showAverageRate;
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
