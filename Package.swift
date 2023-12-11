// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Rudder-Appsflyer",
    platforms: [
        .iOS("13.0"), .tvOS("11.0")
    ],
    products: [
        .library(
            name: "Rudder-Appsflyer",
            targets: ["Rudder-Appsflyer"]
        )
    ],
    dependencies: [
        .package(name: "AppsFlyerLib", url: "https://github.com/AppsFlyerSDK/AppsFlyerFramework", "6.12.2"..<"6.12.3"),
        .package(name: "Rudder",url: "https://github.com/rudderlabs/rudder-sdk-ios", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Rudder-Appsflyer",
            dependencies: [
                .product(name: "AppsFlyerLib", package: "AppsFlyerLib"),
                .product(name: "Rudder", package: "Rudder"),
            ],
            path: "Rudder-Appsflyer",
            sources: ["Classes/"],
            publicHeadersPath: "Classes/",
            cSettings: [
                .headerSearchPath("Classes/")
            ]
        )
    ]
)
