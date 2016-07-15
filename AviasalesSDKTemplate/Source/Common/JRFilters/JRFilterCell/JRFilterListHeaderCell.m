//
//  JRFilterListHeaderCell.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterListHeaderCell.h"

@implementation JRFilterListHeaderCell

- (void)setItem:(JRFilterListHeaderItem *)item {
    _item = item;
    
    self.headerTitle.text = item.tilte;
}

- (void)setExpand:(BOOL)expand {
}

@end
