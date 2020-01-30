// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "AlgorithmBits",
    products: [
        .library(
            name: "AlgorithmBits",
            targets: ["AlgorithmBits"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AlgorithmBits",
            dependencies: []),
        .testTarget(
            name: "AlgorithmBitsTests",
            dependencies: ["AlgorithmBits"]),
    ]
)
