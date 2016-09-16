//
//  ASFilterCellWithOneThumbSlider.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRTableViewCell.h"


@class JRFilterOneThumbSliderItem;


@interface JRFilterCellWithOneThumbSlider : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellAttLabel;
@property (weak, nonatomic) IBOutlet UISlider *cellSlider;

@property (strong, nonatomic) JRFilterOneThumbSliderItem *item;

@end
