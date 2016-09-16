//
//  UIFont+Factory.m
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 27.05.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "UIFont+Factory.h"

@implementation UIFont(Factory)
+ (UIFont *)mediumSystemFontOfSize:(CGFloat)fontSize {
    if (iOSVersionGreaterThanOrEqualTo(@"8.2")) {
        return [self systemFontOfSize:fontSize weight:UIFontWeightMedium];
    } else {
        return [UIFont fontWithName:@"HelveticaNeue-Medium" size:fontSize];
    }
}
@end
