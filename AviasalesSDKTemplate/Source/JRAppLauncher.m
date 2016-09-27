//
//  JRAppLauncher.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRAppLauncher.h"
#import "JRAdvertisementManager.h"
#import "JRSearchFormVC.h"
#import "JRScreenSceneController.h"

@implementation JRAppLauncher

+ (void)startServicesWithAPIToken:(NSString *)APIToken
                    partnerMarker:(NSString *)partnerMarker
                   appodealAPIKey:(NSString *)appodealAPIKey {
    
    // Aviasale SDK
    [AviasalesSDK setupWithConfiguration:[AviasalesSDKInitialConfiguration configurationWithAPIToken:APIToken APILocale:[NSLocale currentLocale].localeIdentifier partnerMarker:partnerMarker]];

    if (appodealAPIKey) {
        // Advertisement initializing
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JRAdvertisementManager *const adManager = [JRAdvertisementManager sharedInstance];
            [adManager initializeAppodealWithAPIKey:appodealAPIKey testingEnabled:NO];
        });
    }
}

+ (UIViewController *)rootViewController {
    return [JRSearchFormVC new];
}

+ (UIViewController *)rootViewControllerWithIpadWideLayout {
    UIViewController *rootVC = [JRAppLauncher rootViewController];
    UIViewController *container = nil;
    if (iPhone()) {
        container = rootVC;
    } else {
        id scene = [JRScreenSceneController screenSceneWithMainViewController:rootVC
                                                                        width:[JRScreenSceneController screenSceneControllerWideViewWidth]
                                                      accessoryViewController:nil
                                                                        width:kNilOptions
                                                               exclusiveFocus:NO];
        JRScreenSceneController *sceneController = [JRScreenSceneController new];
        [sceneController setViewControllers:@[scene] animated:NO];
        
        container = sceneController;
    }
    
    return container;
}

@end
