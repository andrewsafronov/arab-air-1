//
//  ASTAdvertisementManager.h
//  AviasalesSDKTemplate
//
//  Created by Denis Chaschin on 04.04.16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ASTVideoAdPlayer;
@class AppodealNativeAdView;

@interface ASTAdvertisementManager : NSObject
+ (instancetype)sharedInstance;

@property (assign, nonatomic) BOOL showsAdDuringSearch;
@property (assign, nonatomic) BOOL showsAdOnSearchResults;

/**
 * @param testingEnabled Установите YES, чтобы загружать тестовую рекламу. Работает только в DEBUG режиме.
 *
 */
- (void)initializeAppodealWithAPIKey:(NSString *)appodealAPIKey testingEnabled:(BOOL)testingEnabled;

- (void)presentFullScreenAdFromViewControllerIfNeeded:(UIViewController *)viewController;

- (id<ASTVideoAdPlayer>)presentVideoAdInViewIfNeeded:(UIView *)view
                               rootViewController:(UIViewController *)viewController;

- (void)viewController:(UIViewController *)viewController
  loadNativeAdWithSize:(CGSize)size
              ifNeededWithCallback:(void (^)(AppodealNativeAdView *))callback;

- (void)loadAviasalesAdWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo
                 ifNeededWithCallback:(void(^)(UIView *))callback;
@end
