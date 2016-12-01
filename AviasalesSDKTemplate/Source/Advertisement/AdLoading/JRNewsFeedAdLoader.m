//
//  JRNewsFeedAdLoader.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Appodeal/APDNativeAd.h>
#import "JRNewsFeedAdLoader.h"
#import "JRNativeAdLoader.h"
#import "JRNewsFeedNativeAdView.h"

@interface JRNewsFeedAdLoader ()

@property (strong, nonatomic) JRNativeAdLoader *loader;

@end

@implementation JRNewsFeedAdLoader

- (instancetype)init {
    if (self = [super init]) {
        _loader = [[JRNativeAdLoader alloc] init];
    }
    return self;
}

- (void)loadAdWithSize:(CGSize)size callback:(void(^)(JRNewsFeedNativeAdView *))callback {
    __weak typeof(self) bself = self;
    [self.loader loadAdWithType:APDNativeAdTypeNoVideo callback:^(APDNativeAd *ad) {
        typeof(self) sSelf = bself;
        if (sSelf == nil) {
            return;
        }
        
        if (ad == nil || ![ad.title isKindOfClass:[NSString class]] || ad.title.length == 0) {
            callback(nil);
            return;
        }

        JRNewsFeedNativeAdView *adView = nil;

        if (sSelf.rootViewController != nil) {
            adView = [JRNewsFeedNativeAdView viewWithNativeAd:ad];
            [ad attachToView:adView viewController:sSelf.rootViewController];
        }

        callback(adView);
    }];
}

@end
