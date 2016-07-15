//
//  JRAverageRateView.m
//  aviasales
//
//  Created by Ruslan Shevchuk on 28/11/12.
//
//

#import "JRAverageRateView.h"

#import "UIImage+JRUIImage.h"

#define kJRAverageRateViewWidth 59
#define kJRAverageRateViewNumberOfStart 5

@implementation JRAverageRateView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.starts.image = [[self.starts image] imageTintedWithColor:[UIColor blueColor]];
}

- (void)setRating:(NSNumber *)rating {
	if (rating) {
		[self setHidden:NO];
		CGRect starsFrame = _starts.frame;
		starsFrame.size.width = kJRAverageRateViewWidth / kJRAverageRateViewNumberOfStart * [rating floatValue];
		[self.starts setFrame:starsFrame];
	} else {
		[self setHidden:YES];
	}
}

@end
