//
//  ASFilterCellWithTwoThumbsSlider.h
//  aviasales
//
//  Created by Ruslan on 24/12/12.
//
//

#import "JRTableViewCell.h"


@class JRFilterTwoThumbSliderItem;
@class NMRangeSlider;


@interface JRFilterCellWithTwoThumbsSlider : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellAttLabel;
@property (weak, nonatomic) IBOutlet NMRangeSlider *cellSlider;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *dayTimeButtons;
@property (strong, nonatomic) JRFilterTwoThumbSliderItem *item;

@end
