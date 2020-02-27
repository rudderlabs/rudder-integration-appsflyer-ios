//
//  RudderAdjustFactory.h
//  FBSnapshotTestCase
//
//  Created by Arnab Pal on 29/10/19.
//

#import <Foundation/Foundation.h>
#import <Rudder/RudderIntegrationFactory.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderAppsflyerFactory : NSObject<RudderIntegrationFactory>

+ (instancetype) instance;

@end

NS_ASSUME_NONNULL_END
