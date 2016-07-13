//
//  ColorScheme.h
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 02.06.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ColorScheme : NSObject

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

@end
