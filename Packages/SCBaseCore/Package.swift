// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SCBaseCore",
    platforms: [.iOS(.v17)],
    products: [.library(name: "SCBaseCore", targets: ["SCBaseCore"])],
    targets: [
        .target(name: "SCBaseCore"),
        .testTarget(name: "SCBaseCoreTests", dependencies: ["SCBaseCore"])
    ]
)
