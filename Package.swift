// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSNetworkVapor",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(name: "PSNetworkVapor", targets: ["PSNetworkVapor"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tiagopoleze/PSNetwork", branch: "main"),
        .package(url: "https://github.com/vapor/vapor", from: "4.0.0")
    ],
    targets: [
        .target(name: "PSNetworkVapor", dependencies: ["PSNetwork", .product(name: "Vapor", package: "vapor")]),
        .testTarget(name: "PSNetworkVaporTests", dependencies: ["PSNetworkVapor"])
    ]
)
