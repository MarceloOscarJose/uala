// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SCFeatureCitySearch",
    platforms: [.iOS(.v17)],
    products: [.library(name: "SCFeatureCitySearch", targets: ["SCFeatureCitySearch"])],
    dependencies: [.package(path: "../SCBaseCore")],
    targets: [
        .target(name: "SCFeatureCitySearch", dependencies: ["SCBaseCore"]),
        .testTarget(name: "SCFeatureCitySearchTests", dependencies: ["SCFeatureCitySearch", "SCBaseCore"]),
    ]
)
