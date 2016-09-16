//
//  JRDatePickerDayView.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRDatePickerDayView.h"
#import "NSLayoutConstraint+JRConstraintMake.h"
#import "UIView+JRFadeAnimation.h"
#import "UIImage+JRUIImage.h"
#import "DateUtil.h"
#import "JRColorScheme.h"

@interface JRDatePickerDayView ()

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIImageView *dot;
@property (strong, nonatomic) UILabel *todayLabel;

@end

@implementation JRDatePickerDayView

- (void)setDotHidden:(BOOL)dotHidden {
	_dotHidden = dotHidden;
	if (!_dotHidden && !_dot) {
		_dot = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"JRDatePickerDot"] imageTintedWithColor:[JRColorScheme mainBackgroundColor]]];
		[_dot setTranslatesAutoresizingMaskIntoConstraints:NO];
        
		UIView *dotSuperView = self.superview;
        
		[dotSuperView addSubview:_dot];
        
		[dotSuperView addConstraint:JRConstraintMake(_dot, NSLayoutAttributeRight, NSLayoutRelationEqual, self, NSLayoutAttributeRight, 1, 1)];
		[dotSuperView addConstraint:JRConstraintMake(_dot, NSLayoutAttributeCenterY, NSLayoutRelationEqual, dotSuperView, NSLayoutAttributeCenterY, 1, 0)];
	}
	[_dot setHidden:dotHidden];
}

- (void)setTodayLabelHidden:(BOOL)todayLabelHidden {
	_todayLabelHidden = todayLabelHidden;
	if (!_todayLabelHidden && !_todayLabel) {
		_todayLabel = [UILabel new];
		[_todayLabel setText:[NSLS(@"JR_DATE_PICKER_TODAY_DATE_TITLE") lowercaseString]];
		[_todayLabel setFont:[UIFont systemFontOfSize:9]];
		[_todayLabel setTextColor:[JRColorScheme darkTextColor]];
		[_todayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
		[_todayLabel setTextAlignment:NSTextAlignmentCenter];
		[_todayLabel setAdjustsFontSizeToFitWidth:YES];
		[_todayLabel setMinimumScaleFactor:0];
        
		UIView *labelSuperView = self.superview;
        
		[labelSuperView addSubview:_todayLabel];
		[labelSuperView addConstraint:JRConstraintMake(_todayLabel, NSLayoutAttributeBottom, NSLayoutRelationEqual, labelSuperView, NSLayoutAttributeBottom, 1, -3)];
		[labelSuperView addConstraint:JRConstraintMake(_todayLabel, NSLayoutAttributeLeft, NSLayoutRelationEqual, self, NSLayoutAttributeLeft, 1, 0)];
		[labelSuperView addConstraint:JRConstraintMake(_todayLabel, NSLayoutAttributeRight, NSLayoutRelationEqual, self, NSLayoutAttributeRight, 1, 0)];
	}
	[self updateTodayLabel];
}

- (void)setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
    
	[self updateHighlight];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self updateHighlight];
}

- (void)updateHighlight {
    [self updateTodayLabel];
    [self setBackgroundImageViewHidden:!self.selected && !self.highlighted];
}

- (void)setBackgroundImageViewHidden:(BOOL)hidden {
    if (hidden == NO && _backgroundImageView == nil) {
        UIImage *image = [[UIImage imageNamed:@"JRDatePickerSelectedButton"] imageTintedWithColor:[JRColorScheme mainBackgroundColor]];
        _backgroundImageView = [[UIImageView alloc] initWithImage:image];
        _backgroundImageView.layer.borderWidth = 1;
        _backgroundImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _backgroundImageView.layer.cornerRadius = image.size.height / 2;
        
        [_backgroundImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UIView *bgSuperView = self.superview;
        
        [bgSuperView insertSubview:_backgroundImageView belowSubview:self];
        [bgSuperView addConstraint:JRConstraintMake(_backgroundImageView, NSLayoutAttributeCenterX, NSLayoutRelationEqual, self.titleLabel, NSLayoutAttributeCenterX, 1, 0)];
        [bgSuperView addConstraint:JRConstraintMake(_backgroundImageView, NSLayoutAttributeCenterY, NSLayoutRelationEqual, self.titleLabel, NSLayoutAttributeCenterY, 1, 0)];
    } else {
        _backgroundImageView.layer.borderWidth = 0;
    }
    [_backgroundImageView setHidden:hidden];
}

- (void)updateTodayLabel {
	BOOL selectedOrHighlighted = self.selected || self.highlighted;
	BOOL shouldHideTodayLabel = selectedOrHighlighted || _todayLabelHidden;
	[_todayLabel setHidden:shouldHideTodayLabel];
}

- (void)setDateLabelColor:(UIColor *)dateLabelColor {
    if (_dateLabelColor != dateLabelColor) {
        _dateLabelColor = dateLabelColor;
        [self setTitleColor:_dateLabelColor forState:UIControlStateNormal];
        
        CGFloat alpha = 0;
        [_dateLabelColor getWhite:NULL alpha:&alpha];
        [self setTitleColor:[_dateLabelColor colorWithAlphaComponent:alpha * 0.5] forState:UIControlStateDisabled];
    }
}

- (void)setDate:(NSDate *)date monthItem:(JRDatePickerMonthItem *)monthItem {
	_date = date;
    
	NSString *title = (monthItem.stateObject.weeksStrings)[date];
	[self setTitle:title forState:UIControlStateNormal];
	[self setTitle:title forState:UIControlStateHighlighted];
	[self setTitle:title forState:UIControlStateSelected];
	[self setTitle:title forState:UIControlStateDisabled];
    
    
	BOOL selectedDate = date == monthItem.stateObject.firstSelectedDate || date == monthItem.stateObject.secondSelectedDate;
	[_dot setHidden:!selectedDate];
}

- (NSString *)accessibilityLabel {
    return [DateUtil dayMonthYearStringFromDate:_date];
}

@end
