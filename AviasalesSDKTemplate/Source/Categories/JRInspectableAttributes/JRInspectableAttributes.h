//
//  JRInspectableAttributes.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <UIKit/UIKit.h>


@interface UILabel (JRInspectableAttributes)
@property (nonatomic, assign) IBInspectable CGFloat ipadFontSize;
@property (nonatomic, assign) IBInspectable CGFloat iphone6FontSize;
@property (nonatomic, assign) IBInspectable CGFloat iphone6PlusFontSize;
@property (nonatomic, assign) IBInspectable CGFloat iphone4FontSize;
@property (nonatomic, strong) IBInspectable NSString *JRTextColorKey;
@end


@interface NSLayoutConstraint (JRInspectableAttributes)
@property (nonatomic, assign) IBInspectable CGFloat ipadConstant;
@property (nonatomic, assign) IBInspectable CGFloat iphone6Constant;
@property (nonatomic, assign) IBInspectable CGFloat iphone6PlusConstant;
@property (nonatomic, assign) IBInspectable CGFloat iphone4Constant;
@end


@interface UIView (JRInspectableAttributes)
@property (nonatomic, assign) IBInspectable NSString *JRBackgroundColorKey;
@property (nonatomic, assign) IBInspectable CGFloat JRCornerRadius;
@property (nonatomic, assign) IBInspectable BOOL JRShouldRasterize;
@property (nonatomic, assign) IBInspectable UIColor *JRShadowColor;
@property (nonatomic, assign) IBInspectable NSString *JRShadowColorKey;
@property (nonatomic, assign) IBInspectable CGSize JRShadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat JRShadowOpacity;
@property (nonatomic, assign) IBInspectable CGFloat JRShadowRadius;
@end


@interface UIButton (JRInspectableAttributes)
@property (nonatomic, strong) IBInspectable UIColor *JRNormalColor;
@property (nonatomic, strong) IBInspectable NSString *JRNormalColorKey;
@property (nonatomic, strong) IBInspectable UIColor *JRHighlightedColor;
@property (nonatomic, strong) IBInspectable NSString *JRHighlightedColorKey;
@property (nonatomic, strong) IBInspectable UIColor *JRSelectedColor;
@property (nonatomic, strong) IBInspectable NSString *JRSelectedColorKey;
@property (nonatomic, strong) IBInspectable UIColor *JRDisabledColor;
@property (nonatomic, strong) IBInspectable NSString *JRDisabledColorKey;
@property (nonatomic, strong) IBInspectable NSString *JRTextNormalColorKey;
@property (nonatomic, strong) IBInspectable NSString *JRTextHighlightedColorKey;
@property (nonatomic, strong) IBInspectable NSString *JRTextSelectedColorKey;
@property (nonatomic, strong) IBInspectable NSString *JRTextDisabledColorKey;
@end