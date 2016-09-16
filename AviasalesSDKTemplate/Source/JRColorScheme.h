//
//  JRColorScheme.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>


@interface JRColorScheme : NSObject

+ (UIColor *)colorFromConstant:(NSString *)textColorConstant;

//Background
+ (UIColor *)mainBackgroundColor;
+ (UIColor *)lightBackgroundColor;
+ (UIColor *)darkBackgroundColor;
+ (UIColor *)itemsBackgroundColor;
+ (UIColor *)itemsSelectedBackgroundColor;
+ (UIColor *)iPadSceneShadowColor;

//Tabs
+ (UIColor *)tabBarBackgroundColor;
+ (UIColor *)tabBarSelectedBackgroundColor;
+ (UIColor *)tabBarHighlightedBackgroundColor;

//Text
+ (UIColor *)darkTextColor;
+ (UIColor *)lightTextColor;
+ (UIColor *)inactiveLightTextColor;

+ (UIColor *)labelWithRoundedCornersBackgroundColor;
+ (UIColor *)separatorLineColor;

//Button
+ (UIColor *)buttonBackgroundColor;
+ (UIColor *)buttonSelectedBackgroundColor;
+ (UIColor *)buttonHighlightedBackgroundColor;
+ (UIColor *)buttonShadowColor;

//Popover
+ (UIColor *)popoverTintColor;
+ (UIColor *)popoverBackgroundColor;

//Rating stars
+ (UIColor *)ratingStarDefaultColor;
+ (UIColor *)ratingStarSelectedColor;

@end
