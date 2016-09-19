//
//  JRAppDelegate.m
//
//  Copyright 2016 Go Travel Un Limited
//  This code is distributed under the terms and conditions of the MIT license.
//

#import "JRSDKSearchInfoUrlCoder.h"
#import "JRAppDelegate.h"
#import "JRAppLauncher.h"
#import "JRSearchFormVC.h"
#import "JRNavigationController.h"

// Set your api token, marker and appodeal api key here
static NSString *const kJRAPIToken = @"<your api token here>";
static NSString *const kJRPartnerMarker = @"<your partner marker here>";
static NSString *const kAppodealApiKey = @"<your appodeal api key here>";

@implementation JRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [JRAppLauncher startServicesWithAPIToken:kJRAPIToken
                               partnerMarker:kJRPartnerMarker
                              appodealAPIKey:kAppodealApiKey];
    
    // Screen initializing
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UIViewController *rootVC = [JRAppLauncher rootViewControllerWithIpadWideLayout];
    UIViewController *containerVC;
    if (iPhone()) {
        containerVC = [[JRNavigationController alloc] initWithRootViewController:rootVC];
    } else {
        containerVC = rootVC;
    }
    
    [self.window setRootViewController:containerVC];
    [self.window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    //iOS 9+
    [self performUrlOpening:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //iOS < 9
    [self performUrlOpening:url];
    return YES;
}

- (void)performUrlOpening:(NSURL *)url {
    NSURLComponents *const components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    if ([components.host isEqualToString:@"search"]) {
        NSString *const path = components.path;
        NSString *const searchString = [path substringFromIndex:1];
        JRSearchInfo *const searchInfo = [[[JRSDKSearchInfoUrlCoder alloc] init] searchParamsWithString:searchString];

        UINavigationController *const navigationController = (UINavigationController *)self.window.rootViewController;
        JRSearchFormVC *const searchForm = navigationController.viewControllers[0];

        if ([searchForm isKindOfClass:[JRSearchFormVC class]]) {
            [navigationController popToRootViewControllerAnimated:NO];
            [searchForm startSearchWithSearchInfo:searchInfo];
        }

    }

}


@end
