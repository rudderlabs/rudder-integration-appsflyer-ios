//
//  RudderAdjustIntegration.h
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderAppsflyerIntegration : NSObject<RSIntegration>

@property (nonatomic, strong) AppsFlyerLib *afLib;

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig*) rudderConfig;

@end

NS_ASSUME_NONNULL_END
