// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoogleUrlData",
    products: [
        .library(
            name: "GoogleUrlData",
            type: .dynamic,
            targets: ["GoogleUrlData"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GoogleUrlData",
            dependencies: []),
        .testTarget(
            name: "GoogleUrlDataTests",
            dependencies: ["GoogleUrlData"]),
    ]
)
