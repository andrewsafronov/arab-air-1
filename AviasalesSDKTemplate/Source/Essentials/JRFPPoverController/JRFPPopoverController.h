//
//  JRFPPopoverController.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "FPPopoverController.h"
#import "FXBlurView.h"

#define JRFPPopoverWidthDiffForVerticalArrow 20.f
#define JRFPPopoverHeightDiffForVerticalArrow 40.f

#define JRFPPopoverWidthDiffForHorisontalArrow 40.f
#define JRFPPopoverHeightDiffForHorisontalArrow 20.f

@interface JRFPPopoverController : FPPopoverController

@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *blurTintColor;
@property (nonatomic) BOOL hideOnTouch;
@property (nonatomic) BOOL hideOnRotate;
@property (nonatomic) BOOL accessibilityIsNoModal;

- (id)initWithViewController:(UIViewController*)viewController
                    delegate:(id<FPPopoverControllerDelegate>)delegate
              underlyingView:(UIView *)underlyingView;

- (void)presentPopoverFromPoint:(CGPoint)fromPoint inView:(UIView *)view;

@end
