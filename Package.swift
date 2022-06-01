// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ScaledFont",
    platforms: [
        .iOS(.v11), .tvOS(.v11), .watchOS(.v4)
    ],
    products: [
        .library(
            name: "ScaledFont",
            targets: ["ScaledFont"]),
    ],
    targets: [
        .target(name: "ScaledFont"),
        .testTarget(
            name: "ScaledFontTests",
            dependencies: ["ScaledFont"],
            resources: [.process("TestData")]),
    ]
)

#if swift(>=5.6)
package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
)
#endif
