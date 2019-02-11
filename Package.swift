// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calcifer",
    dependencies: [
        // MARK: - Dependencies
        .package(
            url: "https://github.com/apple/swift-package-manager.git",
            .exact("0.3.0")
        ),
        .package(
            url: "https://github.com/tuist/xcodeproj.git",
            .upToNextMajor(from: "6.4.0")
        ),
        .package(
            url: "https://github.com/httpswift/swifter.git",
            .branch("stable")
        ),
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift.git",
            .exact("0.9.0")
        )
    ],
    targets: [
        .target(
            name: "Calcifer",
            dependencies: [
                "CommandRunner"
            ]
        ),
        .target(
            // MARK: CommandRunner
            name: "CommandRunner",
            dependencies: [
                "FrameworkBuilder",
                "TargetHashCalculator",
                "ArgumentsParser",
                "Utility"
            ]
        ),
        .target(
            // MARK: ArgumentsParser
            name: "ArgumentsParser",
            dependencies: [
                "Utility"
            ]
        ),
        .target(
            // MARK: FrameworkBuilder
            name: "FrameworkBuilder",
            dependencies: [
                "Utility",
                "ArgumentsParser"
            ]
        ),
        .target(
            // MARK: FrameworkBuilder
            name: "TargetHashCalculator",
            dependencies: [
                "Utility",
                "ArgumentsParser",
                "xcodeproj",
                "CryptoSwift",
            ]
        ),
    ]
)
