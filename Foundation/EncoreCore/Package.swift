// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EncoreCore",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "EncoreCore", targets: ["EncoreCore", "EncoreCoreBridge"])
    ],
    dependencies: [
        .package(url: "https://github.com/kaethchen/SwiftRPC.git", branch: "main")
    ],
    targets: [
        .target(name: "EncoreCore", dependencies: ["SwiftRPC"], publicHeadersPath: "include"),
        .target(name: "EncoreCoreBridge", dependencies: ["EncoreCore"])
    ]
)
