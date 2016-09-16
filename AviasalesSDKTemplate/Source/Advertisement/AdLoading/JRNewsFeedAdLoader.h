//
//  JRNewsFeedAdLoader.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>

@class JRNewsFeedNativeAdView;

@interface JRNewsFeedAdLoader : NSObject

@property (weak, nonatomic) UIViewController *rootViewController;

- (void)loadAdWithSize:(CGSize)size callback:(void(^)(JRNewsFeedNativeAdView *))callback;

@end
