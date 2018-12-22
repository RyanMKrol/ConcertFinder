// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "ConcertFinder",
    dependencies: [
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/RyanMKrol/SwiftToolbox.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "ConcertFinderLib",
            dependencies: ["SwiftyJSON", "SwiftToolbox"]),
        .target(
            name: "ConcertFinder",
            dependencies: ["ConcertFinderLib"]),
        .testTarget(
            name: "ConcertFinderTests",
            dependencies: ["ConcertFinder"]),
    ]
)
