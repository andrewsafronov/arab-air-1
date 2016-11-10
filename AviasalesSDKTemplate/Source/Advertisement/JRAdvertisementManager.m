//
//  JRAdvertisementManager.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Appodeal/Appodeal.h>

#import "JRAdvertisementManager.h"
#import "JRVideoAdLoader.h"
#import "JRNewsFeedAdLoader.h"
#import "JRAviasalesAdLoader.h"

@implementation JRAdvertisementManager {
    NSMutableSet *_adLoaders;
}

+ (instancetype)sharedInstance {
    static JRAdvertisementManager *result = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        result = [[JRAdvertisementManager alloc] init];
    });
    return result;
}

- (instancetype)init {
    if (self = [super init]) {
        _showsAdDuringSearch = YES;
        _showsAdOnSearchResults = YES;
        _adLoaders = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)initializeAppodealWithAPIKey:(NSString *)appodealAPIKey testingEnabled:(BOOL)testingEnabled {
#ifdef DEBUG
    [Appodeal setTestingEnabled:testingEnabled];
#endif
    [Appodeal initializeWithApiKey:appodealAPIKey
                             types:AppodealAdTypeInterstitial | AppodealAdTypeNativeAd];
}

- (void)presentFullScreenAdFromViewControllerIfNeeded:(UIViewController *)viewController {
    [Appodeal showAd:AppodealShowStyleVideoOrInterstitial rootViewController:viewController];
}

- (void)presentVideoAdInViewIfNeeded:(UIView *)view
                                 rootViewController:(UIViewController *)viewController{
    if (!self.showsAdDuringSearch) {
        return;
    }

    JRVideoAdLoader *const videoLoader = [[JRVideoAdLoader alloc] init];
    videoLoader.rootViewController = viewController;

    NSMutableSet *const loaders = _adLoaders;
    [loaders addObject:videoLoader];

    __weak UIViewController *weakViewController = viewController;
    [videoLoader loadVideoAd:^(APDMediaView *adView, APDNativeAd *ad) {
        [loaders removeObject:videoLoader];

        if (adView != nil) {
            adView.frame = view.bounds;
            [view addSubview:adView];
            [ad attachToView:view viewController:viewController];
        } else {
            UIViewController *const viewController = weakViewController;
            if (viewController) {
                [Appodeal showAd:AppodealShowStyleInterstitial rootViewController:viewController];
            }
        }
    }];
}

- (void)viewController:(UIViewController *)viewController
  loadNativeAdWithSize:(CGSize)size
  ifNeededWithCallback:(void (^)(JRNewsFeedNativeAdView *))callback; {
    if (callback == nil) {
        return;
    }

    if (!self.showsAdOnSearchResults) {
        callback(nil);
    }

    JRNewsFeedAdLoader *const loader = [[JRNewsFeedAdLoader alloc] init];
    loader.rootViewController = viewController;

    NSMutableSet *const loaders = _adLoaders;
    [loaders addObject:loader];

    [loader loadAdWithSize:size callback:^(JRNewsFeedNativeAdView *adView) {
        [loaders removeObject:loader];
        callback(adView);
    }];
}

- (void)loadAviasalesAdWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                 ifNeededWithCallback:(void(^)(UIView *))callback {
    if (callback == nil) {
        return;
    }
    JRAviasalesAdLoader *const loader = [[JRAviasalesAdLoader alloc] initWithSearchInfo:searchInfo];

    NSMutableSet *const loaders = _adLoaders;
    [loaders addObject:loader];

    [loader loadAdWithCallback:^(UIView *adView) {
        [loaders removeObject:loader];
        callback(adView);
    }];
}

@end
