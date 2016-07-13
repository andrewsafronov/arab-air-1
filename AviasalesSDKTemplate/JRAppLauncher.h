//
//  JRAppLauncher.h
//  AviasalesSDKTemplate
//
//  Created by Dmitry Ryumin on 04/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRAppLauncher : NSObject

+ (void)startServicesWithAPIToken:(NSString *)APIToken
                    partnerMarker:(NSString *)partnerMarker
                   appodealAPIKey:(NSString *)appodealAPIKey;
+ (UIViewController *)rootViewController;
+ (UIViewController *)rootViewControllerWithIpadWideLayout;

@end
