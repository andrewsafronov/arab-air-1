//
//  JRAviasalesAdLoader.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRAviasalesAdLoader.h"

#import <AviasalesSDK/AviasalesSDK.h>

@interface JRAviasalesAdLoader ()

@property (strong, nonatomic) id<JRSDKSearchInfo> searchInfo;
@property (assign, nonatomic) BOOL loadingAd;
@property (copy, nonatomic) void (^callback)(UIView *);

@end

@implementation JRAviasalesAdLoader

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo  {
    if (self = [super init]) {
        _searchInfo = searchInfo;
    }
    return self;
}

- (void)loadAdWithCallback:(void (^)(UIView *adView))callback {
    if (self.loadingAd) {
        return; //Loading has already started
    }

    if (callback == nil) {
        return; //No need to load something
    }

    self.callback = callback;
    self.loadingAd = YES;
    __weak typeof(self) weakSelf = self;
    [[AviasalesSDK sharedInstance].adsManager loadAdsViewForSearchResultsWithSearchInfo:self.searchInfo
                                                              completion:^(AviasalesSDKAdsView * _Nullable adsView, NSError * _Nullable error) {
                                                                  if (weakSelf.callback) {
                                                                      weakSelf.callback(adsView);
                                                                  }

                                                                  [weakSelf clean];
                                                              }];
}

#pragma mark - Private

- (void)clean {
    self.callback = nil;
    self.loadingAd = NO;
}

@end
