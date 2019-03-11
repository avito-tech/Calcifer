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
                "XcodeProjectBuilder",
                "XcodeProjectChecksumCalculator",
                "XcodeProjectPatcher",
                "XcodeBuildEnvironmentParametersParser",
                "RemoteCachePreparer",
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
        // MARK: RemoteCachePreparer
        .target(
            name: "RemoteCachePreparer",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "XcodeProjectChecksumCalculator",
                "XcodeProjectPatcher",
                "XcodeProjectBuilder",
                "Checksum",
                "Toolkit"
            ]
        ),
        // MARK: XcodeProjectBuilder
        .target(
            name: "XcodeProjectBuilder",
            dependencies: [
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        // MARK: XcodeProjectChecksumCalculator
        .target(
            name: "XcodeProjectChecksumCalculator",
            dependencies: [
                "ArgumentsParser",
                "xcodeproj",
                "Checksum"
            ]
        ),
        .testTarget(
            name: "XcodeProjectChecksumCalculatorTests",
            dependencies: [
                "XcodeProjectChecksumCalculator",
                "xcodeproj",
                "Toolkit"
            ]
        ),
        // MARK: XcodeProjectPatcher
        .target(
            name: "XcodeProjectPatcher",
            dependencies: [
                "ArgumentsParser",
                "xcodeproj",
                "Toolkit"
            ]
        ),
        // MARK: XcodeBuildEnvironmentParametersParser
        .target(
            name: "XcodeBuildEnvironmentParametersParser",
            dependencies: [
                "ArgumentsParser",
                "Checksum",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "XcodeBuildEnvironmentParametersParserTests",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
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
