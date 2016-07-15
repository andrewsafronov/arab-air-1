//
//  JRSearchFormCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchFormCell.h"
#import "JRSearchFormComplexSegmentCell.h"
#import "JRSearchInfo.h"
#import "ColorScheme.h"

@interface JRSearchFormCell ()

@end

@implementation JRSearchFormCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self updateCell];
}

- (JRSearchInfo *)searchInfo
{
	return [_item.itemDelegate searchInfo];
}

- (void)setupBackgroundViews
{
	self.customBackgroundView.backgroundColor = [UIColor clearColor];
	self.customSelectedBackgroundView.backgroundColor = [ColorScheme itemsSelectedBackgroundColor];
}

- (void)setItem:(JRSearchFormItem *)item
{
	_item = item;
    
	[self setupBackgroundViews];
    
	[self updateCell];
}

- (void)updateCell
{
    
}

- (void)action
{
    
}

@end
