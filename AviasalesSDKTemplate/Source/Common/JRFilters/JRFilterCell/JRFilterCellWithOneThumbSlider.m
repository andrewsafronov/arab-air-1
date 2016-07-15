//
//  ASFilterCellWithOneThumbSlider.m
//  aviasales
//
//  Created by Ruslan on 24/12/12.
//
//

#import "JRFilterCellWithOneThumbSlider.h"

#import "JRFilterOneThumbSliderItem.h"
#import "ColorScheme.h"

#import "UIImage+JRUIImage.h"


@interface JRFilterOneThumbSliderItem ()

@end


@implementation JRFilterCellWithOneThumbSlider

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.separatorInset = UIEdgeInsetsMake(0.0, 21.0, 0.0, 0.0);
    
    [self setupSlider];
    
    self.cellLabel.textColor = [ColorScheme darkTextColor];
    self.cellAttLabel.textColor = [ColorScheme darkTextColor];
}

#pragma mark - Public methds

- (void)setItem:(JRFilterOneThumbSliderItem *)item {
    _item = item;
    
    self.cellSlider.minimumValue = item.minValue;
    self.cellSlider.maximumValue = item.maxValue;
    self.cellSlider.value = item.currentValue;
    
    self.cellAttLabel.attributedText = [item attributedStringValue];
    self.cellLabel.text = [item tilte];
}

#pragma mark - Private methds

- (void)setupSlider {
    UIImage *minTarckImage = [[UIImage imageNamed:@"JRSliderMaxImg"] imageTintedWithColor:[ColorScheme darkBackgroundColor]];
    minTarckImage = [minTarckImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 5.f, 0.f, 5.f)];
    UIImage *maxTarckImage = [UIImage imageNamed:@"JRSliderMinImg"];
    maxTarckImage = [maxTarckImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.f, 5.f, 0.f, 5.f)];
    
    [self.cellSlider setThumbImage:[UIImage imageNamed:@"JRSliderImg"]  forState:UIControlStateNormal];
    [self.cellSlider setThumbImage:[UIImage imageNamed:@"JRSliderImgHighlighted"] forState:UIControlStateHighlighted];
    [self.cellSlider setMinimumTrackImage:minTarckImage  forState: UIControlStateNormal];
    [self.cellSlider setMaximumTrackImage:maxTarckImage forState:UIControlStateNormal];
}

- (IBAction)valueDidChanged:(id)sender {
    self.item.currentValue = self.cellSlider.value;
    self.item.filterAction();
    
    self.cellAttLabel.attributedText = [self.item attributedStringValue];
}

@end
