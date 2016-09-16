//
//  JRSearchFormTravelClassCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchFormTravelClassCell.h"
#import "NSLayoutConstraint+JRConstraintMake.h"
#import "JRSegmentedControl.h"
#import "UIImage+JRUIImage.h"
#import "JRSearchInfoUtils.h"
#import "JRColorScheme.h"

@interface JRSearchFormTravelClassCell ()<JRSegmentedControlDelegate>

@property (strong, nonatomic) JRSegmentedControl *segControl;

@property (weak, nonatomic) IBOutlet UILabel *travelClassLabel;
@property (weak, nonatomic) IBOutlet UIImageView *travelClassIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowsRightMarginConstraint;

@end


@implementation JRSearchFormTravelClassCell {
	UIImageView *_travelClassImage;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_travelClassIcon setImage:[UIImage imageWithColor:[JRColorScheme buttonBackgroundColor]]];
}

- (void)updateCell {
    // TODO:
//	BOOL isEconomy = self.searchInfo.travelClass == JRSDKTravelClassEconomy || self.searchInfo.travelClass == JRSDKTravelClassPremiumEconomy;
//	UIImage *image = [UIImage imageNamed:isEconomy ? @"JRSearchFormTravelClassEconomy" : @"JRSearchFormTravelClassBusiness"];
//    image = [image imageTintedWithColor:[JRC SF_CELL_IMAGES_TINT]];
//    [_travelClassImage setImage:image];
    [_travelClassLabel setText:[JRSearchInfoUtils travelClassStringWithTravelClass:self.searchInfo.travelClass]];
}

- (void)segmentedControl:(JRSegmentedControl *)segmentedControl clickedButtonAtIndex:(NSUInteger)buttonIndex {
    [self.searchInfo setTravelClass:buttonIndex == 0 ? JRSDKTravelClassEconomy : JRSDKTravelClassBusiness];
}

- (void)action {
    [self.item.itemDelegate showTravelClassPickerFromView:_travelClassLabel];
}

@end
