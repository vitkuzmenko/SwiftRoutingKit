// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftRoutingKit",
    platforms: [
        .iOS(.v10),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "SwiftRoutingKit",
            targets: ["SwiftRoutingKit"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/Swinject/Swinject.git",
            from: "2.7.1"
        )
    ],
    targets: [
        .target(
            name: "SwiftRoutingKit",
            dependencies: ["Swinject"]
        ),
    ]
)
