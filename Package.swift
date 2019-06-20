// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Calcifer",
    dependencies: [
        // MARK: - Dependencies
        .package(
            url: "https://github.com/apple/swift-package-manager.git",
            .branch("swift-5.0-branch")
        ),
        .package(
            url: "https://github.com/CognitiveDisson/xcodeproj",
            .branch("deadlock-fix")
        ),
        .package(
            url: "https://github.com/httpswift/swifter.git",
            .exact("1.4.6")
        ),
        .package(
            url: "https://github.com/weichsel/ZIPFoundation/",
            .exact("0.9.8")
        ),
        .package(
            url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git",
            .exact("1.7.0")
        ),
        .package(
            url: "https://github.com/daltoniam/Starscream.git",
            .exact("3.1.0")
        ),
        .package(
            url: "https://github.com/avito-tech/GraphiteClient.git",
            .exact("0.1.0")
        ),
    ],
    targets: [
        // MARK: Calcifer
        .target(
            name: "Calcifer",
            dependencies: [
                "Toolkit",
                "ArgumentsParser",
                "CommandRunner",
                "XcodeProjectBuilder",
                "XcodeProjectChecksumCalculator",
                "XcodeProjectPatcher",
                "DSYMSymbolizer",
                "XcodeBuildEnvironmentParametersParser",
                "RemoteCachePreparer",
                "BuildStepIntegrator",
                "Daemon",
                "LaunchdManager",
                "CalciferVersionShipper",
                "CalciferUpdater",
                "CalciferBinaryInstaller",
                "CalciferConfig",
                "DaemonClient"
            ]
        ),
        // MARK: CommandRunner
        .target(
            name: "CommandRunner",
            dependencies: [
                "Toolkit",
                "ArgumentsParser",
            ]
        ),
        // MARK: ArgumentsParser
        .target(
            name: "ArgumentsParser",
            dependencies: [
                "Toolkit"
            ]
        ),
        // MARK: StatisticLogger
        .target(
            name: "StatisticLogger",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "GraphiteClient",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "StatisticLoggerTests",
            dependencies: [
                "StatisticLogger"
            ]
        ),
        // MARK: RemoteCachePreparer
        .target(
            name: "RemoteCachePreparer",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "XcodeProjectChecksumCalculator",
                "BuildProductCacheStorage",
                "BuildArtifacts",
                "XcodeProjectPatcher",
                "XcodeProjectBuilder",
                "CalciferConfig",
                "StatisticLogger",
                "DSYMSymbolizer",
                "Checksum",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "RemoteCachePreparerTests",
            dependencies: [
                "RemoteCachePreparer"
            ]
        ),
        // MARK: BuildProductCacheStorage
        .target(
            name: "BuildProductCacheStorage",
            dependencies: [
                "XcodeProjectChecksumCalculator",
                "ZIPFoundation",
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "BuildProductCacheStorageTests",
            dependencies: [
                "BuildProductCacheStorage",
                "Mock"
            ]
        ),
        // MARK: BuildArtifacts
        .target(
            name: "BuildArtifacts",
            dependencies: [
                "XcodeProjectChecksumCalculator",
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "BuildArtifactsTests",
            dependencies: [
                "BuildArtifacts"
            ]
        ),
        // MARK: XcodeProjectBuilder
        .target(
            name: "XcodeProjectBuilder",
            dependencies: [
                "ShellCommand",
                "CalciferConfig",
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "XcodeProjectBuilderTests",
            dependencies: [
                "XcodeProjectBuilder",
                "Mock"
            ]
        ),
        // MARK: XcodeProjectChecksumCalculator
        .target(
            name: "XcodeProjCache",
            dependencies: [
                "XcodeProj",
                "Checksum"
            ]
        ),
        // MARK: XcodeProjectChecksumCalculator
        .target(
            name: "XcodeProjectChecksumCalculator",
            dependencies: [
                "ArgumentsParser",
                "XcodeProjCache",
                "XcodeProj",
                "Checksum"
            ]
        ),
        .testTarget(
            name: "XcodeProjectChecksumCalculatorTests",
            dependencies: [
                "XcodeProjectChecksumCalculator"
            ]
        ),
        // MARK: XcodeProjectPatcher
        .target(
            name: "XcodeProjectPatcher",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "ArgumentsParser",
                "XcodeProjCache",
                "XcodeProj",
                "Toolkit"
            ]
        ),
        // MARK: DSYMSymbolizer
        .target(
            name: "DSYMSymbolizer",
            dependencies: [
                "ShellCommand",
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "DSYMSymbolizerTests",
            dependencies: [
                "DSYMSymbolizer",
                "Mock"
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
        // MARK: LaunchdManager
        .target(
            name: "LaunchdManager",
            dependencies: [
                "ShellCommand",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "LaunchdManagerTests",
            dependencies: [
                "LaunchdManager",
                "Mock"
            ]
        ),
        // MARK: DaemonModels
        .target(
            name: "DaemonModels",
            dependencies: [
                "Toolkit"
            ]
        ),
        // MARK: Daemon
        .target(
            name: "Daemon",
            dependencies: [
                "RemoteCachePreparer",
                "DaemonModels",
                "CalciferConfig",
                "ArgumentsParser",
                "CommandRunner",
                "ShellCommand",
                "Swifter"
            ]
        ),
        // MARK: DaemonClient
        .target(
            name: "DaemonClient",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "ArgumentsParser",
                "CalciferConfig",
                "DaemonModels",
                "Starscream",
                "Toolkit"
            ]
        ),
        // MARK: CalciferConfig
        .target(
            name: "CalciferConfig",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "CalciferConfigTests",
            dependencies: [
                "CalciferConfig"
            ]
        ),
        // MARK: CalciferVersionShipper
        .target(
            name: "CalciferVersionShipper",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "ZIPFoundation",
                "CalciferConfig",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "CalciferVersionShipperTests",
            dependencies: [
                "CalciferVersionShipper",
                "Mock"
            ]
        ),
        // MARK: CalciferBinaryInstaller
        .target(
            name: "CalciferBinaryInstaller",
            dependencies: [
                "LaunchdManager",
                "ArgumentsParser",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "CalciferBinaryInstallerTests",
            dependencies: [
                "CalciferBinaryInstaller",
                "Mock"
            ]
        ),
        // MARK: CalciferUpdater
        .target(
            name: "CalciferUpdater",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "CalciferConfig",
                "ShellCommand",
                "Toolkit"
            ]
        ),
        .testTarget(
            name: "CalciferUpdaterTests",
            dependencies: [
                "CalciferUpdater",
                "Mock"
            ]
        ),
        // MARK: BuildStepIntegrator
        .target(
            name: "BuildStepIntegrator",
            dependencies: [
                "XcodeProj",
                "ArgumentsParser",
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
        // MARK: ShellCommand
        .target(
            name: "ShellCommand",
            dependencies: [
                "Toolkit"
            ]
        ),
        // MARK: Toolkit
        .target(
            name: "Toolkit",
            dependencies: [
                "SwiftyBeaver",
                "SPMUtility"
            ]
        ),
        // MARK: Mock
        .target(
            name: "Mock",
            dependencies: [
                "XcodeBuildEnvironmentParametersParser",
                "ShellCommand"
            ],
            path: "Tests/Mock/"
        ),
    ]
)
