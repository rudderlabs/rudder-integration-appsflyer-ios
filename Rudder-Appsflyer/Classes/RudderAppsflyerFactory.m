//
//  RudderAdjustFactory.m
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import "RudderAppsflyerFactory.h"
#import "RudderAppsflyerIntegration.h"

@implementation RudderAppsflyerFactory

static RudderAppsflyerFactory *sharedInstance;

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)key {
    return @"AppsFlyer";
}

- (nonnull id<RSIntegration>)initiate:(nonnull NSDictionary *)config client:(nonnull RSClient *)client rudderConfig:(nonnull RSConfig *)rudderConfig {
    [RSLogger logDebug:@"Creating RudderIntegrationFactory"];
    return [[RudderAppsflyerIntegration alloc] initWithConfig:config withAnalytics:client withRudderConfig:rudderConfig];
}

@end
