// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "ScaledFont",
    platforms: [
        .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
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

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(.enableExperimentalFeature("StrictConcurrency"))
    target.swiftSettings = settings
}
