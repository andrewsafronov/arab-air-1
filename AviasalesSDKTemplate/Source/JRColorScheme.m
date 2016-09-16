//
//  JRColorScheme.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRColorScheme.h"

#define COLOR_WITH_WHITE(A) [[UIColor alloc] initWithWhite : ((float)A/255.0f)alpha : 1]
#define COLOR_WITH_RED(A, B, C) COLOR_WITH_ALPHA(A, B, C, 1)
#define COLOR_WITH_ALPHA(A, B, C, D) [[UIColor alloc] initWithRed : (float)A/255.0f green : (float)B/255.0f blue : (float)C/255.0f alpha : (float)D]
#define COLOR_WITH_PATTERN(A) [[UIColor alloc] initWithPatternImage :[UIImage imageNamed:A]]

/**
 * H - 0..255
 * S - 0..100
 * B - 0..100
 */
#define COLOR_WITH_HUE(H, S, B) COLOR_WITH_HSBA(H, S, B, 1)
#define COLOR_WITH_HSBA(H, S, B, A) [UIColor colorWithHue:H/360.f saturation:S/100.f brightness:B/100.f alpha:A]

@implementation JRColorScheme
+ (UIColor *)colorFromConstant:(NSString *)textColorConstant {
    NSParameterAssert(![textColorConstant isEqualToString:@"colorFromConstant"]);

    UIColor *result;

    SEL selector = NSSelectorFromString(textColorConstant);
    if ([self respondsToSelector: selector]) {
        IMP imp = [self methodForSelector:selector];
        UIColor* (*func)(id, SEL) = (void *)imp;
        result = func(self, selector);
    } else {
        NSLog(@"tried to create color with unsupported constant %@", textColorConstant);
    }
    return result;
}

+ (UIColor *)mainBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 89);
}

+ (UIColor *)lightBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)darkBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 82);
}

+ (UIColor *)itemsBackgroundColor {
    return [UIColor whiteColor];
}

+ (UIColor *)itemsSelectedBackgroundColor {
    return COLOR_WITH_WHITE(230);
}

+ (UIColor *)iPadSceneShadowColor {
    return [[UIColor blackColor] colorWithAlphaComponent:0.33];
}

+ (UIColor *)tabBarBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 88);
}

+ (UIColor *)tabBarSelectedBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 85);
}

+ (UIColor *)tabBarHighlightedBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 86);
}

+ (UIColor *)darkTextColor {
    return COLOR_WITH_HUE(0, 0, 38);
}

+ (UIColor *)lightTextColor {
    return COLOR_WITH_HUE(0, 0, 67);
}

+ (UIColor *)inactiveLightTextColor {
    return COLOR_WITH_HUE(0, 0, 66);
}

+ (UIColor *)labelWithRoundedCornersBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 85);
}

+ (UIColor *)separatorLineColor {
    return COLOR_WITH_HUE(0, 0, 59);
}

+ (UIColor *)buttonBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 85);
}

+ (UIColor *)buttonSelectedBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 80);
}

+ (UIColor *)buttonHighlightedBackgroundColor {
    return COLOR_WITH_HUE(0, 0, 80);
}

+ (UIColor *)buttonShadowColor {
    return COLOR_WITH_HUE(0, 0, 78);
}

+ (UIColor *)popoverTintColor {
    return [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

+ (UIColor *)popoverBackgroundColor {
    return [UIColor darkGrayColor];
}

+ (UIColor *)ratingStarDefaultColor {
    return COLOR_WITH_ALPHA(255, 155, 16, 0.4);
}

+ (UIColor *)ratingStarSelectedColor {
    return COLOR_WITH_RED(255, 154, 13);
}

@end
