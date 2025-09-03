// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SCFeatureHome",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "SCFeatureHome", targets: ["SCFeatureHome"])
    ],
    dependencies: [
        .package(path: "../SCBaseCore"),
        .package(path: "../SCBasePersistence"),
        .package(path: "../SCBaseNetworking"),
        .package(path: "../SCFeatureCitySearch"),
        .package(path: "../SCFeatureMap")
    ],
    targets: [
        .target(
            name: "SCFeatureHome",
            dependencies: [
                "SCBaseCore",
                "SCBasePersistence",
                "SCBaseNetworking",
                "SCFeatureCitySearch",
                "SCFeatureMap"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SCFeatureHomeTests",
            dependencies: ["SCFeatureHome"]
        )
    ]
)
