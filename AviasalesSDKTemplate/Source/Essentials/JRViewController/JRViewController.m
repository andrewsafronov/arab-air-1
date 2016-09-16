//
//  JRViewController.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRViewController.h"
#import "JRScreenScene.h"
#import "JRViewController+JRScreenScene.h"
#import "UIViewController+JRScreenSceneController.h"
#import "UIImage+JRUIImage.h"
#import "JRColorScheme.h"


@interface JRViewController ()

@property (weak, nonatomic) UIButton *menuButton;

@end


@implementation JRViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	[self setTitle:NSStringFromClass(self.class)];
	[self updateBackgroundColor];
    
    if ([self.navigationController.viewControllers count] > 1 && self.scene.accessoryViewController != self) {
        [self addPopButtonToNavigationItem];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationController.navigationBar setTranslucent:NO];
	[self.navigationController.navigationBar.layer removeAllAnimations];
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, nil);
        if (self.navigationItem.titleView) {
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, self.navigationItem.titleView.accessibilityLabel);
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    _viewIsVisible = NO;
    
    if (iPhone()) {
        [self.navigationController.navigationBar.layer removeAllAnimations];
    }
}

- (void)updateBackgroundColor
{
	[self.view setBackgroundColor:[JRColorScheme mainBackgroundColor]];
}

- (void)addPopButtonToNavigationItem
{
    UIBarButtonItem *popButton = [UINavigationItem barItemWithImageName:kJRBaseBackButtonImageName
                                                                 target:self
                                                                 action:@selector(popAction)];
    
    UIButton *button = (UIButton *)popButton.customView;
    [button setImage:[[button imageForState:UIControlStateNormal] imageTintedWithColor:[JRColorScheme darkTextColor]] forState:UIControlStateNormal];
    
	[self.navigationItem setLeftBarButtonItem:popButton];
}

- (void)popAction
{
	if (iPhone()) {
		[self.navigationController popViewControllerAnimated:YES];
	} else if (iPad()) {
		if (self.sceneViewController) {
			[self.sceneViewController popViewControllerAnimated:YES];
		} else if (self.navigationController) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (void)popActionToRoot
{
	if ([self scene]) {
        [self.sceneViewController popToRootViewControllerAnimated:YES];
	} else {
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _viewIsVisible = YES;
}

- (BOOL)shouldShowNavigationBar {
    return YES;
}

@end
