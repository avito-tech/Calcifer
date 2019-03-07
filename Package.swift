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
        ),
    ],
    targets: [
        // MARK: Calcifer
        .target(
            name: "Calcifer",
            dependencies: [
                "Toolkit",
                "CommandRunner"
            ]
        ),
        // MARK: CommandRunner
        .target(
            name: "CommandRunner",
            dependencies: [
                "Toolkit",
                "FrameworkBuilder",
                "ProjectChecksumCalculator",
                "ProjectPatcher",
                "BuildParametersParser",
                "BuildRunner",
                "ArgumentsParser"
            ]
        ),
        // MARK: ArgumentsParser
        .target(
            name: "ArgumentsParser",
            dependencies: [
                "Toolkit"
            ]
        ),
        // MARK: BuildRunner
        .target(
            name: "BuildRunner",
            dependencies: [
                "BuildParametersParser",
                "ProjectChecksumCalculator",
                "ProjectPatcher",
                "FrameworkBuilder",
                "Checksum",
                "Toolkit"
            ]
        ),
        // MARK: FrameworkBuilder
        .target(
            name: "FrameworkBuilder",
            dependencies: [
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        // MARK: ProjectChecksumCalculator
        .target(
            name: "ProjectChecksumCalculator",
            dependencies: [
                "ArgumentsParser",
                "xcodeproj",
                "Checksum"
            ]
        ),
        .testTarget(
            name: "ProjectChecksumCalculatorTests",
            dependencies: [
                "ProjectChecksumCalculator",
                "xcodeproj",
                "Toolkit"
            ]
        ),
        // MARK: ProjectPatcher
        .target(
            name: "ProjectPatcher",
            dependencies: [
                "ArgumentsParser",
                "xcodeproj",
                "Toolkit"
            ]
        ),
        // MARK: BuildParametersParser
        .target(
            name: "BuildParametersParser",
            dependencies: [
                "ArgumentsParser",
                "Checksum",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "BuildParametersParserTests",
            dependencies: [
                "BuildParametersParser",
                "Toolkit"
            ]
        ),
        // MARK: Checksum
        .target(
            name: "Checksum",
            dependencies: [
                "Toolkit"
            ]
        ),
        // MARK: Toolkit
        .target(
            name: "Toolkit",
            dependencies: [
                "Utility"
            ]
        ),
    ]
)
