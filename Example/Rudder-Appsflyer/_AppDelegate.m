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

static NSString *DATA_PLANE_URL = @"https://6fce-2405-201-c001-18cd-f190-b1cc-2af3-7028.ngrok.io";
static NSString *WRITE_KEY = @"1pAKRv50y15Ti6UWpYroGJaO0Dj";

@implementation _AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // First Initialize the Appsflyer iOS SDK
    [[AppsFlyerLib shared] setAppsFlyerDevKey:@"<devKey>"];
    [[AppsFlyerLib shared] setAppleAppID:@"<appleAppId"];
    [AppsFlyerLib shared].isDebug = YES;
    [[AppsFlyerLib shared] start];
    
    
    // And then initialize the Rudder SDK
    RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
    [builder withDataPlaneUrl:DATA_PLANE_URL];
    [builder withTrackLifecycleEvens:YES];
    [builder withRecordScreenViews:YES];
    [builder withFactory:[RudderAppsflyerFactory instance]];
    [builder withLoglevel:RSLogLevelDebug];
    [RSClient getInstance:WRITE_KEY config:[builder build]];
    
    [[RSClient sharedInstance] track:@"Order Completed" properties:@{
    @"checkout_id": @"12345",
    @"order_id": @"1234",
    @"affiliation": @"Apple Store",
    @"total": @20,
    @"revenue": @15.0,
    @"shipping": @22,
    @"tax": @1,
    @"discount": @1.5,
    @"coupon": @"ImagePro",
    @"currency": @"USD",
    @"products": @[
      @{
        @"product_id": @"123",
        @"sku": @"G-32",
        @"name": @"Monopoly",
        @"price": @14,
        @"quantity": @1,
        @"category": @"Games",
        @"url": @"https://www.website.com/product/path",
        @"image_url": @"https://www.website.com/product/path.jpg",
      },
      @{
        @"product_id": @"345",
        @"sku": @"F-32",
        @"name": @"UNO",
        @"price": @3.45,
        @"quantity": @2,
        @"category": @"Games",
      },
    ],
  }];
    
    [[RSClient sharedInstance] track:@"first_purchase" properties:@{
    @"checkout_id": @"12345",
    @"order_id": @"1234",
    @"affiliation": @"Apple Store",
    @"total": @20,
    @"revenue": @15.0,
    @"shipping": @22,
    @"tax": @1,
    @"discount": @1.5,
    @"coupon": @"ImagePro",
    @"currency": @"USD",
    @"products": @[
      @{
        @"product_id": @"123",
        @"sku": @"G-32",
        @"name": @"Monopoly",
        @"price": @14,
        @"quantity": @1,
        @"category": @"Games",
        @"url": @"https://www.website.com/product/path",
        @"image_url": @"https://www.website.com/product/path.jpg",
      },
      @{
        @"product_id": @"345",
        @"sku": @"F-32",
        @"name": @"UNO",
        @"price": @3.45,
        @"quantity": @2,
        @"category": @"Games",
      },
    ],
  }];
    
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

@end
