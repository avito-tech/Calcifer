// swift-tools-version:4.2
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

//        .package(
//            url: "https://github.com/tuist/xcodeproj.git",
//            .upToNextMajor(from: "6.4.0")
//        ),
        .package(
            path: "/Users/vvsmal/Rep/xcodeproj"
        ),
        .package(
            url: "https://github.com/httpswift/swifter.git",
            .branch("stable")
        )
    ],
    targets: [
        .target(
            // MARK: Calcifer
            name: "Calcifer",
            dependencies: [
                "Toolkit",
                "CommandRunner"
            ]
        ),
        .target(
            // MARK: CommandRunner
            name: "CommandRunner",
            dependencies: [
                "Toolkit",
                "FrameworkBuilder",
                "ProjectChecksumCalculator",
                "ArgumentsParser"
            ]
        ),
        .target(
            // MARK: ArgumentsParser
            name: "ArgumentsParser",
            dependencies: [
                "Toolkit",
                "Utility"
            ]
        ),
        .target(
            // MARK: FrameworkBuilder
            name: "FrameworkBuilder",
            dependencies: [
                "ArgumentsParser",
                "Toolkit",
                "Utility"
            ]
        ),
        .target(
            // MARK: ProjectChecksumCalculator
            name: "ProjectChecksumCalculator",
            dependencies: [
                "ArgumentsParser",
                "xcodeproj",
                "Toolkit",
                "Utility"
            ]
        ),
        .target(
            // MARK: Toolkit
            name: "Toolkit",
            dependencies: []
        ),
    ]
)
