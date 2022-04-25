# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## Integrating AppsFlyer with RudderStack's iOS SDK

1. Add [Appsflyer](https://www.appsflyer.com) as a destination in the [Dashboard](https://app.rudderstack.com/) and provide ```devKey``` and `appleAppId` from your iTunes profile.

2. Rudder-Appsflyer is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Rudder-Appsflyer'
```

3. Initialize the `Appsflyer` SDK before initializing the Rudder SDK as shown below:

```
#import <AppsFlyerLib/AppsFlyerLib.h>

[[AppsFlyerLib shared] setAppsFlyerDevKey:<devKey>];
[[AppsFlyerLib shared] setAppleAppID:<appleAppId>];
[AppsFlyerLib shared].isDebug = YES;
[[AppsFlyerLib shared] start];
```

## Initialize ```RSClient```

Put this code in your ```AppDelegate.m``` file under the method ```didFinishLaunchingWithOptions```
```
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withDataPlaneUrl:DATA_PLANE_URL];
[builder withFactory:[RudderAppsflyerFactory instance]];
[RSClient getInstance:WRITE_KEY config:[builder build]];
```

## Send Events

Follow the steps from the [RudderStack iOS SDK](https://github.com/rudderlabs/rudder-sdk-ios).

## Contact Us

If you come across any issues while configuring or using this integration, please feel free to start a conversation on our [Slack](https://github.com/rudderlabs/rudder-integration-braze-ios/pull/4) channel. We will be happy to help you.
