// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SCFeatureMap",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "SCFeatureMap", targets: ["SCFeatureMap"]),
    ],
    dependencies: [
        .package(path: "../SCBaseCore"),
    ],
    targets: [
        .target(name: "SCFeatureMap", dependencies: ["SCBaseCore"]),
        .testTarget(name: "SCFeatureMapTests", dependencies: ["SCFeatureMap"]),
    ]
)
