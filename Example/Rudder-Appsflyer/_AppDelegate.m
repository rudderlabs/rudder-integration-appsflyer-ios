//
//  _AppDelegate.m
//  Rudder-Appsflyer
//
//  Created by arnabp92 on 02/21/2020.
//  Copyright (c) 2020 arnabp92. All rights reserved.
//s

#import "_AppDelegate.h"
#import <Rudder/Rudder.h>
#import "RudderAppsflyerFactory.h"
#import <AppsFlyerLib/AppsFlyerLib.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "Rudder_Appsflyer_Example-Swift.h"

@implementation _AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // First Initialize the Appsflyer iOS SDK
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"<devKey>"];
    [[AppsFlyerLib shared] setAppleAppID:@"<appleAppId"];
    [AppsFlyerLib shared].isDebug = YES;
    
    [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:30];
    
    
    /// Copy the `SampleRudderConfig.plist` and rename it to`RudderConfig.plist` on the same directory.
    /// Update the values as per your need.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RudderConfig" ofType:@"plist"];
    if (path != nil) {
        NSURL *url = [NSURL fileURLWithPath:path];
        RudderConfig *rudderConfig = [RudderConfig createFrom:url];
        if (rudderConfig != nil) {
            RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
            [builder withDataPlaneUrl:rudderConfig.PROD_DATA_PLANE_URL];
            [builder withTrackLifecycleEvens:YES];
            [builder withRecordScreenViews:YES];
            [builder withFactory:[RudderAppsflyerFactory instance]];
            [builder withLoglevel:RSLogLevelDebug];
            [RSClient getInstance:rudderConfig.WRITE_KEY config:[builder build]];
        }
    }
    
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
    [[AppsFlyerLib shared] start];
    
         
         [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
           NSLog(@"Status: %lu", (unsigned long)status);
         }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
