//
//  JRNavigationController.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRNavigationController.h"
#import "UIImage+JRUIImage.h"
#import "UIFont+Factory.h"
#import "ColorScheme.h"
#import "JRViewController.h"

@interface JRNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>

@property (assign, nonatomic) BOOL pushInProgress;
@property (strong, nonatomic) NSDate *lastInteractivePopGestureBeginDate;

@property (nonatomic, strong) UIButton *screenshotAlertsButton;
@property (nonatomic, strong) UIButton *screenshotPopoversButton;

@end

@implementation JRNavigationController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupNavigationBar];
	if (iPhone()) {
        [self setDelegate:self];
        [self.interactivePopGestureRecognizer setDelegate:self];
		[self.view setBackgroundColor:[ColorScheme darkTextColor]];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController.navigationBar.layer removeAllAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.navigationController.navigationBar.layer removeAllAnimations];
}

- (void)setupNavigationBar {
    NSDictionary *titleTextAttributes = @{
        NSFontAttributeName : [UIFont mediumSystemFontOfSize: 15],
        NSForegroundColorAttributeName :  [ColorScheme darkTextColor]
    };
    
	UINavigationBar *const navigationBar = self.navigationBar;
    [navigationBar setTitleTextAttributes:titleTextAttributes];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[JRViewController class]]) {
        [self setNavigationBarHidden:![(JRViewController *)viewController shouldShowNavigationBar] animated:animated];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        
        BOOL topViewControllerIsEqualToFirstViewController = self.topViewController == self.viewControllers.firstObject;
        
        NSTimeInterval secondsAfterLastBegin = _lastInteractivePopGestureBeginDate ?
        [[NSDate date] timeIntervalSinceDate:_lastInteractivePopGestureBeginDate] : MAXFLOAT;
        
        if (self.pushInProgress == YES ||
            topViewControllerIsEqualToFirstViewController == YES ||
            secondsAfterLastBegin < 2) {
            return NO;
        } else {
            self.lastInteractivePopGestureBeginDate = [NSDate date];
            return YES;
        }
    }
    return YES;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushInProgress = YES;
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.pushInProgress = NO;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)removeAllViewControllersExceptCurrent
{
    self.viewControllers = @[[self.viewControllers lastObject]];
}

#pragma mark autorotation

- (BOOL)shouldAutorotate
{
    if (iPhone() && !_allowedIphoneAutorotate) {
        return NO;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (iPhone() && !_allowedIphoneAutorotate) {
        return UIInterfaceOrientationMaskPortrait;
    }
	return [super supportedInterfaceOrientations];
}

@end
