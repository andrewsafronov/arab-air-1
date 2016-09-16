//
//  JRFilterListHeaderCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRFilterListHeaderCell.h"


@interface JRFilterListHeaderCell ()

@property (nonatomic, assign) BOOL isAnimationPerform;

@end


@implementation JRFilterListHeaderCell

- (void)setItem:(JRFilterListHeaderItem *)item {
    _item = item;
    _expanded = item.expanded;
    
    self.openIndicator.transform = CGAffineTransformMakeScale(1.0, item.expanded ? 1.0 : -1.0);
    self.headerTitle.text = item.tilte;
}

- (void)setExpanded:(BOOL)expanded {
    [self setExpanded:expanded animated:NO];
}

- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated {
    _expanded = expanded;
    
    self.item.expanded = expanded;
    
    NSTimeInterval duration = animated ? 0.2 : 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.openIndicator.transform = CGAffineTransformMakeScale(1.0, self.expanded ? 1.0 : -1.0);
    }];
}

@end
