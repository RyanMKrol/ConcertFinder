// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConcertFinder",
    dependencies: [
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.2.0"),
        .package(url: "https://github.com/IBM-Swift/Configuration.git", from: "3.0.0"),
        .package(url: "https://github.com/IBM-Swift/Swift-SMTP.git", from: "5.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ConcertFinderLib",
            dependencies: ["SwiftyJSON", "Configuration", "SwiftSMTP"]),
        .target(
            name: "ConcertFinder",
            dependencies: ["ConcertFinderLib"]),
        .testTarget(
            name: "ConcertFinderTests",
            dependencies: ["ConcertFinder"]),
    ]
)
