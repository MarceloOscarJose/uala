// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "SCBasePersistence",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "SCBasePersistence", targets: ["SCBasePersistence"])
    ],
    dependencies: [
        .package(path: "../SCBaseCore"),
        .package(url: "https://github.com/groue/GRDB.swift.git", from: "7.6.1")
    ],
    targets: [
        .target(
            name: "SCBasePersistence",
            dependencies: ["SCBaseCore", .product(name: "GRDB", package: "GRDB.swift")]
        ),
        .testTarget(
            name: "SCBasePersistenceTests",
            dependencies: ["SCBasePersistence", "SCBaseCore", .product(name: "GRDB", package: "GRDB.swift")]
        )
    ]
)
