// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PickleBallMatching",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "PickleBallMatchingCore",
            targets: ["PickleBallMatchingCore"]
        )
    ],
    targets: [
        .target(
            name: "PickleBallMatchingCore",
            path: "Sources/PickleBallMatchingCore"
        ),
        .testTarget(
            name: "PickleBallMatchingCoreTests",
            dependencies: ["PickleBallMatchingCore"],
            path: "Tests/PickleBallMatchingCoreTests"
        )
    ]
)
