// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "E2EE",
    platforms: [
        .macOS(.v14), // macOS 14 and later
        .iOS(.v17) // iOS 17 and later
    ],
    products: [
        .library(
            name: "E2EE",
            targets: ["E2EE"])
    ],
    dependencies: [
        .package(url: "https://github.com/sentryco/Logger.git", branch: "main"),
        .package(url: "https://github.com/sentryco/Key", branch: "main"),
        .package(url: "https://github.com/sentryco/Cipher", branch: "main"),
        .package(url: "https://github.com/sentryco/Dice.git", branch: "main") // Adds Dice as a dependency
    ],
    targets: [
        .target(
            name: "E2EE",
            dependencies: ["Logger", "Key", "Cipher", "Dice"]),
        .testTarget(
            name: "E2EETests",
            dependencies: ["E2EE", "Logger", "Key", "Cipher", "Dice"])
    ]
)
