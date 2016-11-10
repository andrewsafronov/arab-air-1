//
//  JRNativeAdLoader.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Appodeal/APDNativeAdLoader.h>

#import "JRNativeAdLoader.h"

@interface JRNativeAdLoader () <APDNativeAdLoaderDelegate>

@property (strong, nonatomic) APDNativeAdLoader *appodeal;
@property (copy, nonatomic) void (^callback)(APDNativeAd *);

@end

@implementation JRNativeAdLoader

- (instancetype)init {
    if (self = [super init]) {
        _appodeal = [[APDNativeAdLoader alloc] init];
        _appodeal.delegate = self;
    }
    return self;
}

- (void)loadAdWithType:(APDNativeAdType)type callback:(void(^)(APDNativeAd *))callback {
    if (callback == nil) {
        return;
    }
    if (self.callback != nil) {
        NSLog(@"ad loading already started");
        return;
    }

    self.callback = callback;

    [_appodeal loadAdWithType:type];
}

#pragma mark - <APDNativeAdLoaderDelegate>

- (void)nativeAdLoader:(APDNativeAdLoader *)loader didLoadNativeAds:(NSArray <__kindof APDNativeAd *> *)nativeAds {
    self.callback(nativeAds.firstObject);
    [self clean];
}

- (void)nativeAdLoader:(APDNativeAdLoader *)loader didLoadNativeAd:(APDNativeAd *)nativeAd {
    self.callback(nativeAd);
    [self clean];
}

- (void)nativeAdLoader:(APDNativeAdLoader *)loader didFailToLoadWithError:(NSError *)error {
    MLOG(@"error during native ad loading %@", error);
    self.callback(nil);
    [self clean];
}

#pragma mark - Private

- (void)clean {
    self.callback = nil;
    self.appodeal = nil;
}

@end

