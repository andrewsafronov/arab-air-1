//
//  ASFilterCellWithOneThumbSlider.h
//  aviasales
//
//  Created by Ruslan on 24/12/12.
//
//

#import "JRTableViewCell.h"


@class JRFilterOneThumbSliderItem;


@interface JRFilterCellWithOneThumbSlider : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellAttLabel;
@property (weak, nonatomic) IBOutlet UISlider *cellSlider;

@property (strong, nonatomic) JRFilterOneThumbSliderItem *item;

@end
