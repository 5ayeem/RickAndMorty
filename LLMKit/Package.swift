// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LLMKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "LLMKit", targets: ["LLMKit"]),
    ],
    dependencies: [
        // Local package dependency — adjust the path if your layout differs
        .package(path: "../NetworkKit")
    ],
    targets: [
        .target(
            name: "LLMKit",
            dependencies: [
                // This must match the *library product name* exposed by NetworkKit's Package.swift
                .product(name: "NetworkKit", package: "NetworkKit")
            ]
        ),
        .testTarget(
            name: "LLMKitTests",
            dependencies: ["LLMKit"]
        )
    ]
)
