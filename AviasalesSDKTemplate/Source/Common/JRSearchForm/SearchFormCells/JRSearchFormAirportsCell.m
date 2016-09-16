//
//  JRSearchFormAirportsCell.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSearchFormAirportsCell.h"
#import "JRSearchFormSimpleSearchTableView.h"
#import "UIImage+JRUIImage.h"
#import "UIView+JRFadeAnimation.h"
#import "JRColorScheme.h"

static const CGFloat JRSearchFormAirportsCellAnimationDuration = 0.3;


@interface JRSearchFormAirportsCell ()

@property (weak, nonatomic) IBOutlet JRSearchFormSimpleSearchTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end


@implementation JRSearchFormAirportsCell

- (void)setupChangeButton {
	UIImage *changeButtonImage = [[_changeButton imageForState:UIControlStateNormal] imageTintedWithColor:[JRColorScheme buttonBackgroundColor] fraction:0.1];
	[_changeButton setImage:changeButtonImage forState:UIControlStateHighlighted];
	[UIView animateWithDuration:JRSearchFormAirportsCellAnimationDuration
                          delay:kNilOptions
                        options:UIViewAnimationOptionOverrideInheritedOptions
                     animations:^{
                         CGFloat alpha = [self changeButtonIsAvalible] ? 1 : 0;
                         [_changeButton setAlpha:alpha];
                     } completion:NULL];
}

- (void)initialSetup {
	JRSearchFormItem *originItem = [[JRSearchFormItem alloc] initWithType:JRSearchFormTableViewOriginAirportItem itemDelegate:self.item.itemDelegate];
	JRSearchFormItem *destinationItem = [[JRSearchFormItem alloc] initWithType:JRSearchFormTableViewDestinationAirportItem itemDelegate:self.item.itemDelegate];
	[_tableView setItems:@[originItem, destinationItem]];
	[_tableView reloadData];
}

- (void)awakeFromNib {
	[super awakeFromNib];
    
	[self setupChangeButton];
}

- (void)updateCell {
	[self setupChangeButton];
	[_tableView reloadData];
}

- (void)setItem:(JRSearchFormItem *)item {
	[super setItem:item];
    
	[self initialSetup];
}

- (IBAction)chageAction:(UIButton *)sender{
	JRTravelSegment *travelSegment = self.searchInfo.travelSegments.firstObject;
	id<JRSDKAirport> originAirport = travelSegment.originAirport;
	travelSegment.originAirport = travelSegment.destinationAirport;
	travelSegment.destinationAirport = originAirport;
	[self updateCell];
	[UIView addTransitionFadeToView:self duration:JRSearchFormAirportsCellAnimationDuration];
}

- (BOOL)changeButtonIsAvalible{
	JRTravelSegment *travelSegment = self.searchInfo.travelSegments.firstObject;
	if ((travelSegment.originAirport || travelSegment.destinationAirport) &&
        ![JRSDKModelUtils airport:travelSegment.originAirport isEqualToAirport:travelSegment.destinationAirport]) {
		return YES;
	} else {
		return NO;
	}
}

@end
