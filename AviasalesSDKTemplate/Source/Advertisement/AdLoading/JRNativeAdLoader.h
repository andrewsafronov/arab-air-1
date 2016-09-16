//
//  JRNativeAdLoader.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>
#import <Appodeal/APDDefines.h>

@class APDNativeAd;

@interface JRNativeAdLoader : NSObject

- (void)loadAdWithType:(APDNativeAdType)type callback:(void(^)(APDNativeAd *))callback;

@end
