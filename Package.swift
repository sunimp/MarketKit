// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "MarketKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "MarketKit",
            targets: ["MarketKit"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/groue/GRDB.swift.git", .upToNextMajor(from: "6.29.3")),
        .package(url: "https://github.com/tristanhimmelman/ObjectMapper.git", .upToNextMajor(from: "4.4.3")),
        .package(url: "https://github.com/sunimp/SWToolKit.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/sunimp/SWExtensions.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat.git", from: "0.54.6"),
    ],
    targets: [
        .target(
            name: "MarketKit",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
                "ObjectMapper",
                "SWToolKit",
                "SWExtensions"
            ],
            resources: [
                .copy("Dumps"),
            ]
        ),
    ]
)
