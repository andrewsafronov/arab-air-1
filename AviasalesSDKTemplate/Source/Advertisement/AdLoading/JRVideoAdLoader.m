//
//  JRVideoAdLoader.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRVideoAdLoader.h"
#import "JRNativeAdLoader.h"
#import <Appodeal/APDMediaView.h>
#import <Appodeal/APDNativeAd.h>

@interface JRVideoAdLoader()

@property (strong, nonatomic) JRNativeAdLoader *nativeAdLoader;

@end


@implementation JRVideoAdLoader

- (instancetype)init {
    if (self = [super init]) {
        _nativeAdLoader = [[JRNativeAdLoader alloc] init];
    }
    return self;
}

- (void)loadVideoAd:(void(^)(APDMediaView *, APDNativeAd *))callback {
    if (callback == nil) {
        return;
    }

    __weak typeof(self) bself = self;

    [self.nativeAdLoader loadAdWithType:APDNativeAdTypeVideo callback:^(APDNativeAd *ad) {
        typeof(self) sSelf = bself;
        if (sSelf == nil) {
            return;
        }

        if (ad == nil || !ad.containsVideo) {
            callback(nil, nil);
            return;
        }

        APDMediaView *result = nil;

        if (sSelf.rootViewController != nil) {
            result = [[APDMediaView alloc] initWithFrame:CGRectZero];
            result.type = APDMediaViewTypeMainImage;
            [result setNativeAd:ad rootViewController:sSelf.rootViewController];
        }

        callback(result, ad);
    }];
}

@end
