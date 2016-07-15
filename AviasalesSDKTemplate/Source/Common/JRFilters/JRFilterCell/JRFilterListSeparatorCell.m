//
//  JRFilterListSeparatorCell.m
//  Aviasales iOS Apps
//
//  Created by Ruslan Shevchuk on 31/03/14.
//
//

#import "JRFilterListSeparatorCell.h"

#import "ColorScheme.h"

@interface JRFilterListSeparatorCell ()

@end


@implementation JRFilterListSeparatorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = self.contentView.backgroundColor = [ColorScheme darkTextColor];
}

@end
