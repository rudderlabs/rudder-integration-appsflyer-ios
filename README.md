<p align="center">
  <a href="https://rudderstack.com/">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://cdn.rudderlabs.com/brand/logo_watermark_dark.png">
      <img alt="RudderStack" width="512" src="https://cdn.rudderlabs.com/brand/logo_watermark_light.png">
    </picture>
  </a>
</p>

# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## Integrating AppsFlyer with RudderStack's iOS SDK

1. Add [Appsflyer](https://www.appsflyer.com) as a destination in the [Dashboard](https://app.rudderstack.com/) and provide ```devKey``` and `appleAppId` from your iTunes profile.

2. Rudder-Appsflyer is available through [**CocoaPods**](https://cocoapods.org) and [**Swift Package Manager (SPM)**](https://www.swift.org/package-manager/).
### CocoaPods
```ruby
pod 'Rudder-Appsflyer'
```
### Swift Package Manager (SPM)

You can also add the RudderStack iOS SDK via Swift Package Mangaer, via one of the following two ways:

* [Xcode](#xcode)
* [Swift](#swift)

#### Xcode

* Go to **File** - **Add Package**, as shown:

![Adding a package](https://user-images.githubusercontent.com/59817155/140903027-286a1d64-f5d5-4041-9827-47b6cef76a46.png)

* Enter the package repository (`git@github.com/rudderlabs/rudder-integration-appsflyer-ios.git`) in the search bar.

* In **Dependency Rule**, select **Up to Next Major Version** and enter `4.0.0` as the value, as shown:

![Setting dependency](https://user-images.githubusercontent.com/59817155/145574696-8c849749-13e0-40d5-aacb-3fccb5c8e67d.png)

* Select the project to which you want to add the package.

* Finally, click on **Add Package**.

#### Swift

To leverage package.swift, use the following snippet in your project:

```swift
// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Rudder-Appsflyer",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Rudder-Appsflyer",
            targets: ["Rudder-Appsflyer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "git@github.com/rudderlabs/rudder-integration-appsflyer-ios.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Rudder-Appsflyer",
            dependencies: [
                .product(name: "Rudder-Appsflyer", package: "rudder-integration-appsflyer-ios")
            ]),
        .testTarget(
            name: "RudderStackTests",
            dependencies: ["Rudder-Appsflyer"]),
    ]
)
```

3. Initialize the `Appsflyer` SDK before initializing the Rudder SDK as shown below:

```
#import <AppsFlyerLib/AppsFlyerLib.h>

[[AppsFlyerLib shared] initWithDevKey:<devKey> appleAppId:<appleAppId>];
[AppsFlyerLib shared].isDebug = YES;

// AppsFlyer SDK v7 never starts automatically. Call start from inside the
// session-ready listener, after any pre-conditions (ATT/consent) resolve.
[[AppsFlyerLib shared] registerSessionReadyListener:^{
    [[AppsFlyerLib shared] start];
}];
```

> **Note:** If `initWithDevKey:appleAppId:` and `start` are not called, this integration
> still forwards events to the AppsFlyer SDK, but the SDK will not send them to
> AppsFlyer — with no error reported.

## Migrating to 4.x (AppsFlyer SDK 7)

Version 4.0.0 of this integration requires AppsFlyer SDK 7.x. If you are upgrading from 3.x:

* Replace `setAppsFlyerDevKey:` and `setAppleAppID:` with `initWithDevKey:appleAppId:` — the old setters are read-only properties in AppsFlyer 7.
* Move your `start` call from `applicationDidBecomeActive:` into a `registerSessionReadyListener:` block — the SDK no longer starts automatically, and starting it from the listener preserves the first session even when you defer `start` for consent or ATT.
* `waitForATTUserAuthorizationWithTimeoutInterval:` is deprecated — collect ATT consent inside the session-ready listener instead.
* The email set via the `identify` event is now hashed on-device (SHA-256) by AppsFlyer's `setUserEmail` API; no change is needed in your `identify` calls.
* To stay on AppsFlyer 6.x, keep using the 3.x releases of this integration.

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
