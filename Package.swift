// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "MarketKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "MarketKit",
            targets: ["MarketKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.4.3")),
        .package(url: "https://github.com/sunimp/WWToolKit.Swift.git", .upToNextMajor(from: "2.0.7")),
        .package(url: "https://github.com/sunimp/WWExtensions.Swift.git", .upToNextMajor(from: "1.0.8")),
    ],
    targets: [
        .target(
            name: "MarketKit",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
                "ObjectMapper",
                .product(name: "WWToolKit", package: "WWToolKit.Swift"),
                .product(name: "WWExtensions", package: "WWExtensions.Swift"),
            ],
            resources: [
                .copy("Dumps"),
            ]
        ),
    ]
)
