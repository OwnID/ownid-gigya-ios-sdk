// swift-tools-version:5.1.1

import PackageDescription

let package = Package(
    name: "OwnIDGigyaSDK",
//    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "OwnIDGigyaSDK",
            targets: ["OwnIDGigyaSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SAP/gigya-swift-sdk.git",
                 from: "1.2.0"),
        .package(url: "https://github.com/OwnID/ownid-core-ios-sdk.git",
                 from: "0.0.0"),
    ],
    targets: [
        .target(name: "OwnIDGigyaSDK",
                dependencies: [
                    .product(name: "OwnIDCoreSDK", package: "ownid-core-ios-sdk"),
                    .product(name: "OwnIDFlowsSDK", package: "ownid-core-ios-sdk"),
                    .product(name: "OwnIDUISDK", package: "ownid-core-ios-sdk"),
                    .product(name: "Gigya", package: "gigya-swift-sdk"),
                ],
                path: "./"),
    ]
)
