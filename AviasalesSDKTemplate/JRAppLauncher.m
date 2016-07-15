//
//  JRAppLauncher.m
//  AviasalesSDKTemplate
//
//  Created by Dmitry Ryumin on 04/07/16.
//  Copyright © 2016 Go Travel Un LImited. All rights reserved.
//

#import "JRAppLauncher.h"
#import "ASTAdvertisementManager.h"
#import "JRSearchFormVC.h"
#import "JRScreenSceneController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation JRAppLauncher

+ (void)startServicesWithAPIToken:(NSString *)APIToken
                    partnerMarker:(NSString *)partnerMarker
                   appodealAPIKey:(NSString *)appodealAPIKey {
#ifndef DEBUG
    [Fabric with:@[[Crashlytics class]]];
#endif
    //TODO выпились крашлитикс перед релизом
    
    // Aviasale SDK
    [AviasalesSDK setupWithConfiguration:[AviasalesSDKInitialConfiguration configurationWithAPIToken:APIToken APILocale:[NSLocale currentLocale].localeIdentifier partnerMarker:partnerMarker]];
    
    // Advertisement initializing
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ASTAdvertisementManager *const adManager = [ASTAdvertisementManager sharedInstance];
        [adManager initializeAppodealWithAPIKey:appodealAPIKey testingEnabled:NO];
    });
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
