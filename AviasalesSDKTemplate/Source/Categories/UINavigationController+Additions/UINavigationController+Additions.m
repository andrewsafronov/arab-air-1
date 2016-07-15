//
//  UINavigationController+Additions.m
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 31.05.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "UINavigationController+Additions.h"

@implementation UINavigationController(Additions)
- (void)replaceTopViewControllerWith:(UIViewController *)viewController {
    NSMutableArray *const viewControllers = [self.viewControllers mutableCopy];
    [viewControllers removeLastObject];
    [viewControllers addObject:viewController];
    self.viewControllers = viewControllers;
}
@end
