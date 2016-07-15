//
//  JRNavigationController.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>

#define kJRNavigationControllerDefaultTextSize 17

@interface JRNavigationController : UINavigationController

@property (nonatomic) BOOL allowedIphoneAutorotate;

- (void)removeAllViewControllersExceptCurrent;

@end
