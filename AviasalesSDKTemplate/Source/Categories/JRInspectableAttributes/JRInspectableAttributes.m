//
//  JRInspectableAttributes.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRInspectableAttributes.h"
#import "UIImage+JRUIImage.h"
#import "JRColorScheme.h"

static inline UIColor *colorFromConstant(NSString *constant) {
    return [JRColorScheme colorFromConstant:constant];
}

@implementation UILabel (JRInspectableAttributes)

- (CGFloat)ipadFontSize {
    return 0;
}

- (void)setIpadFontSize:(CGFloat)ipadFontSize {
    if (iPad()) {
        self.font = [UIFont fontWithName:self.font.fontName size:ipadFontSize];
    }
}

- (CGFloat)iphone6FontSize {
    return 0;
}

- (void)setIphone6FontSize:(CGFloat)iphone6FontSize {
    if (iPhone47Inch()) {
        self.font = [UIFont fontWithName:self.font.fontName size:iphone6FontSize];
    }
}

- (CGFloat)iphone6PlusFontSize {
    return 0;
}

- (void)setIphone6PlusFontSize:(CGFloat)iphone6PlusFontSize {
    if (iPhone55Inch()) {
        self.font = [UIFont fontWithName:self.font.fontName size:iphone6PlusFontSize];
    }
}

- (CGFloat)iphone4FontSize {
    return 0;
}

- (void)setIphone4FontSize:(CGFloat)iphone4FontSize {
    if (iPhone35Inch()) {
        self.font = [UIFont fontWithName:self.font.fontName size:iphone4FontSize];
    }
}

- (NSString *)JRTextColorKey {
    return nil;
}

- (void)setJRTextColorKey:(NSString *)JRTextColorKey {
    self.textColor = colorFromConstant(JRTextColorKey);
}

@end


@implementation NSLayoutConstraint (JRInspectableAttributes)

- (CGFloat)ipadConstant {
    return 0;
}

- (void)setIpadConstant:(CGFloat)ipadConstant {
    if (iPad()) {
        self.constant = ipadConstant;
    }
}

- (CGFloat)iphone6Constant {
    return 0;
}

- (void)setIphone6Constant:(CGFloat)iphone6Constant {
    if (iPhone47Inch()) {
        self.constant = iphone6Constant;
    }
}

- (CGFloat)iphone6PlusConstant {
    return 0;
}

- (void)setIphone6PlusConstant:(CGFloat)iphone6PlusConstant {
    if (iPhone55Inch()) {
        self.constant = iphone6PlusConstant;
    }
}

- (CGFloat)iphone4Constant {
    return 0;
}

- (void)setIphone4Constant:(CGFloat)iphone4Constant {
    if (iPhone35Inch()) {
        self.constant = iphone4Constant;
    }
}

@end


@implementation UIView (JRInspectableAttributes)

- (void)setJRBackgroundColorKey:(NSString *)JRSelectedColorKey {
    self.backgroundColor = colorFromConstant(JRSelectedColorKey);
}

- (NSString *)JRBackgroundColorKey {
    return nil;
}

- (void)setJRCornerRadius:(CGFloat)JRCornerRadius {
    self.layer.cornerRadius = JRCornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)JRCornerRadius {
    return self.layer.cornerRadius;
}

- (void)setJRShouldRasterize:(BOOL)JRShouldRasterize {
    if (JRShouldRasterize) {
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    
    self.layer.shouldRasterize = JRShouldRasterize;
}

- (BOOL)JRShouldRasterize {
    return self.layer.shouldRasterize;
}

- (void)setJRShadowColor:(UIColor *)JRShadowColor {
    self.layer.shadowColor = [JRShadowColor CGColor];
}

- (UIColor *)JRShadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setJRShadowColorKey:(NSString *)JRShadowColorKey {
    [self setJRShadowColor:colorFromConstant(JRShadowColorKey)];
}

- (NSString *)JRShadowColorKey {
    return nil;
}

- (void)setJRShadowOffset:(CGSize)JRShadowOffset {
    self.layer.shadowOffset = JRShadowOffset;
}

- (CGSize)JRShadowOffset {
    return self.layer.shadowOffset;
}

- (void)setJRShadowOpacity:(CGFloat)JRShadowOpacity {
    self.layer.shadowOpacity = JRShadowOpacity;
}

- (CGFloat)JRShadowOpacity {
    return self.layer.shadowOpacity;
}

- (void)setJRShadowRadius:(CGFloat)JRShadowRadius {
    self.layer.shadowRadius = JRShadowRadius;
}

- (CGFloat)JRShadowRadius {
    return self.layer.shadowRadius;
}

@end


@implementation UIButton (JRInspectableAttributes)

- (void)setJRNormalColor:(UIColor *)JRNormalColor {
    [self setBackgroundImage:[UIImage imageWithColor:JRNormalColor] forState:UIControlStateNormal];
}

- (UIColor *)JRNormalColor {
    return nil;
}

- (void)setJRNormalColorKey:(NSString *)JRNormalColorKey {
    [self setJRNormalColor:colorFromConstant(JRNormalColorKey)];
}

- (NSString *)JRNormalColorKey {
    return nil;
}

- (void)setJRHighlightedColor:(UIColor *)JRHighlightedColor {
    [self setBackgroundImage:[UIImage imageWithColor:JRHighlightedColor] forState:UIControlStateHighlighted];
}

- (UIColor *)JRHighlightedColor {
    return nil;
}

- (void)setJRHighlightedColorKey:(NSString *)JRHighlightedColorKey {
    [self setJRHighlightedColor:colorFromConstant(JRHighlightedColorKey)];
}

- (NSString *)JRHighlightedColorKey {
    return nil;
}

- (void)setJRSelectedColor:(UIColor *)JRSelectedColor {
    [self setBackgroundImage:[UIImage imageWithColor:JRSelectedColor] forState:UIControlStateSelected];
}

- (UIColor *)JRSelectedColor {
    return nil;
}

- (void)setJRSelectedColorKey:(NSString *)JRSelectedColorKey {
    [self setJRSelectedColor:colorFromConstant(JRSelectedColorKey)];
}

- (NSString *)JRSelectedColorKey {
    return nil;
}

- (void)setJRDisabledColor:(UIColor *)JRDisabledColor {
    [self setBackgroundImage:[UIImage imageWithColor:JRDisabledColor] forState:UIControlStateDisabled];
}

- (UIColor *)JRDisabledColor {
    return nil;
}

- (void)setJRDisabledColorKey:(NSString *)JRDisabledColorKey {
    [self setJRDisabledColor:colorFromConstant(JRDisabledColorKey)];
}

- (NSString *)JRDisabledColorKey {
    return nil;
}

- (void)setJRTextNormalColorKey:(NSString *)JRTextNormalColorKey {
    [self setTitleColor:colorFromConstant(JRTextNormalColorKey) forState:UIControlStateNormal];
}

- (NSString *)JRTextNormalColorKey {
    return nil;
}

- (void)setJRTextHighlightedColorKey:(NSString *)JRTextHighlightedColorKey {
    [self setTitleColor:colorFromConstant(JRTextHighlightedColorKey) forState:UIControlStateHighlighted];
}

- (NSString *)JRTextHighlightedColorKey {
    return nil;
}

- (void)setJRTextSelectedColorKey:(NSString *)JRTextSelectedColorKey {
    [self setTitleColor:colorFromConstant(JRTextSelectedColorKey) forState:UIControlStateSelected];
}

- (NSString *)JRTextSelectedColorKey {
    return nil;
}

- (void)setJRTextDisabledColorKey:(NSString *)JRTextDisabledColorKey {
    [self setTitleColor:colorFromConstant(JRTextDisabledColorKey) forState:UIControlStateDisabled];
}

- (NSString *)JRTextDisabledColorKey {
    return nil;
}

@end