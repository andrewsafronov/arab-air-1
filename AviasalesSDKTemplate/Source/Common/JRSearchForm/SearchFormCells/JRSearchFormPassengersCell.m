//
//  JRSearchFormPassengersCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchFormPassengersCell.h"
#import "JRSearchInfoUtils.h"
#import "JRSearchFormPassengerPickerView.h"
#import "UIImage+JRUIImage.h"
#import "NSLayoutConstraint+JRConstraintMake.h"
#import "JRColorScheme.h"

@interface JRSearchFormPassengersCell ()

@property (weak, nonatomic) IBOutlet UILabel *passengersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *passengerIcon;
@end


@implementation JRSearchFormPassengersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_passengerIcon setImage:[UIImage imageWithColor:[JRColorScheme buttonBackgroundColor]]];
}

- (void)updateCell {
    NSMutableArray *passengersTextComponents = [NSMutableArray new];
    if (self.searchInfo.adults > 0) {
        [passengersTextComponents addObject:[NSString stringWithFormat:@"%ld\u00a0%@",
                                                                       (long)self.searchInfo.adults,
                                                                       NSLSP(@"JR_SEARCH_FORM_PASSENGERS_ADULTS", self.searchInfo.adults)]];
    }
    if (self.searchInfo.children > 0) {
        [passengersTextComponents addObject:[NSString stringWithFormat:@"%ld\u00a0%@",
                                             (long)self.searchInfo.children,
                                             NSLSP(@"JR_SEARCH_FORM_PASSENGERS_CHILDREN", self.searchInfo.children)]];
    }
    if (self.searchInfo.infants > 0) {
        [passengersTextComponents addObject:[NSString stringWithFormat:@"%ld\u00a0%@",
                                             (long)self.searchInfo.infants,
                                             NSLSP(@"JR_SEARCH_FORM_PASSENGERS_INFANTS", self.searchInfo.infants)]];
    }
    
	[_passengersCountLabel setText:[passengersTextComponents componentsJoinedByString:@", "]];
}

- (void)action {
    [self.item.itemDelegate showPassengerPicker];
}

- (NSString *)accessibilityLabel {
    return _passengersCountLabel.text;
}

@end
