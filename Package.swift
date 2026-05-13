// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "AppShelfKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "AppShelfKit",
            targets: ["AppShelfKit"]
        ),
    ],
    targets: [
        .target(
            name: "AppShelfKit"
        ),
        .testTarget(
            name: "AppShelfKitTests",
            dependencies: ["AppShelfKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
