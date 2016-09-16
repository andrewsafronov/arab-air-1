//
//  JRNewsFeedNativeAdView.h
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 24.08.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APDNativeAd;

@interface JRNewsFeedNativeAdView : UIView
+ (instancetype)viewWithNativeAd:(APDNativeAd *)nativeAd;
@end
