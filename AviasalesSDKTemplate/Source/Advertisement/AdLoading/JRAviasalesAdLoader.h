//
//  JRAviasalesAdLoader.h
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import <Foundation/Foundation.h>

@interface JRAviasalesAdLoader : NSObject

- (instancetype)initWithSearchInfo:(id<JRSDKSearchInfo>)searchInfo;

/**
 * callback - returns nil if error occured
 */
- (void)loadAdWithCallback:(void (^)(UIView *adView))callback;

@end
