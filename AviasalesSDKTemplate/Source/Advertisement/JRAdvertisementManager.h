//
//  JRAdvertisementManager.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>

@class JRNewsFeedNativeAdView;

@interface JRAdvertisementManager : NSObject

@property (assign, nonatomic) BOOL showsAdDuringSearch;
@property (assign, nonatomic) BOOL showsAdOnSearchResults;

+ (instancetype)sharedInstance;

/**
 * @param testingEnabled Установите YES, чтобы загружать тестовую рекламу. Работает только в DEBUG режиме.
 *
 */
- (void)initializeAppodealWithAPIKey:(NSString *)appodealAPIKey testingEnabled:(BOOL)testingEnabled;

- (void)presentFullScreenAdFromViewControllerIfNeeded:(UIViewController *)viewController;

- (void)presentVideoAdInViewIfNeeded:(UIView *)view
                  rootViewController:(UIViewController *)viewController;

- (void)viewController:(UIViewController *)viewController
  loadNativeAdWithSize:(CGSize)size
  ifNeededWithCallback:(void (^)(JRNewsFeedNativeAdView *))callback;

- (void)loadAviasalesAdWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                 ifNeededWithCallback:(void(^)(UIView *))callback;

@end
