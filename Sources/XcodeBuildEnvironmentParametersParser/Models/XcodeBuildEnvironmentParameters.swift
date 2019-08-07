import Foundation

public final class XcodeBuildEnvironmentParameters: Codable {
    // "TARGETNAME": "Some"
    public let targetNameParam: KeyValueParam<String>
    public var targetName: String { return targetNameParam.value }
    // "PROJECT": "Some"
    public let projectParam: KeyValueParam<String>
    public var project: String { return projectParam.value }
    // "PRODUCT_BUNDLE_IDENTIFIER": "io.some.bla"
    public let productBundleIdentifierParam: KeyValueParam<String>
    public var productBundleIdentifier: String { return productBundleIdentifierParam.value }
    // "FULL_PRODUCT_NAME": "Some.app"
    public let fullProductNameParam: KeyValueParam<String>?
    public var fullProductName: String? { return fullProductNameParam?.value }
    // "TARGET_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let targetBuildDirectoryParam: KeyValueParam<String>
    public var targetBuildDirectory: String { return targetBuildDirectoryParam.value }
    // "MODULE_CACHE_DIR": "/Users/admin/DD/ModuleCache.noindex"
    public let moduleCacheDirectoryParam: KeyValueParam<String>
    public var moduleCacheDirectory: String { return moduleCacheDirectoryParam.value }
    // "PROJECT_TEMP_ROOT": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Intermediates.noindex"
    public let projectTemporaryDirectoryParam: KeyValueParam<String>
    public var projectTemporaryDirectory: String { return projectTemporaryDirectoryParam.value }
    // "DWARF_DSYM_FOLDER_PATH": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let dwarfDSYMFolderPathParam: KeyValueParam<String>
    public var dwarfDSYMFolderPath: String { return dwarfDSYMFolderPathParam.value }
    // "DWARF_DSYM_FILE_NAME": "Some.app.dSYM"
    public let dwarfDsymFileNameParam: KeyValueParam<String>
    public var dwarfDsymFileName: String { return dwarfDsymFileNameParam.value }
    // "DEVELOPER_FRAMEWORKS_DIR_QUOTED": "/Users/admin/Downloads/Xcode.app/Contents/Developer/Library/Frameworks"
    public let developerFrameworksDirectoryQuotedParam: KeyValueParam<String>
    public var developerFrameworksDirectoryQuoted: String { return developerFrameworksDirectoryQuotedParam.value }
    // "OBJROOT": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Intermediates.noindex"
    public let objRootParam: KeyValueParam<String>
    public var objRoot: String { return objRootParam.value }
    // "BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products"
    public let buildDirectoryParam: KeyValueParam<String>
    public var buildDirectory: String { return buildDirectoryParam.value }
    // "CONFIGURATION_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let configurationBuildDirectoryParam: KeyValueParam<String>
    public var configurationBuildDirectory: String { return configurationBuildDirectoryParam.value }
    // "PROJECT_FILE_PATH": "/b/Some/Some.xcodeproj"
    public let projectFilePathParam: KeyValueParam<String>
    public var projectFilePath: String { return projectFilePathParam.value }
    // "PROJECT_DIR": "/b/Some",
    public let projectDirectoryParam: KeyValueParam<String>
    public var projectDirectory: String { return projectDirectoryParam.value }
    // "SRCROOT": "/b/Some"
    public let sourceRootParam: KeyValueParam<String>
    public var sourceRoot: String { return sourceRootParam.value }
    
    // "PATH": "/usr/bin"
    public let userBinaryPathParam: KeyValueParam<String>
    public var userBinaryPath: String { return userBinaryPathParam.value }
    
    // "OTHER_LDFLAGS": " -ObjC -ObjC -l\"c++\" -l\"resolv\" -l\"sqlite3\" -l\"stdc++\" -l\"xml2\" -l\"z\" -framework \"AVFoundation\" ..."
    public let otherLDFlagsParam: KeyValueParam<String>
    public var otherLDFlags: String { return otherLDFlagsParam.value }
    // "OTHER_SWIFT_FLAGS": "-DDEBUG -Onone \"-D\" \"COCOAPODS\""
    public let otherSwiftFlagsParam: KeyValueParam<String>
    public var otherSwiftFlags: String { return otherSwiftFlagsParam.value }
    // "GCC_PREPROCESSOR_DEFINITIONS": "Debug DEBUG=1 SWIFT_MODULE_Some COCOAPODS=1 Debug DEBUG=1 SWIFT_MO
    public let gccPreprocessorDefinitionsParam: KeyValueParam<String>
    public var gccPreprocessorDefinitions: String { return gccPreprocessorDefinitionsParam.value }
    
    // "ENABLE_BITCODE": "NO",
    public let enableBitcodeParam: KeyValueParam<Bool>
    public var enableBitcode: Bool { return enableBitcodeParam.value }
    // "ENABLE_TESTABILITY": "YES",
    public let enableTestabilityParam: KeyValueParam<Bool>
    public var enableTestability: Bool { return enableTestabilityParam.value }
    // "PROFILING_CODE": "NO",
    public let profilingCodeParam: KeyValueParam<Bool>
    public var profilingCode: Bool { return profilingCodeParam.value }
    
    // "CURRENT_ARCH": "x86_64"
    public let currentArchitectureParam: KeyValueParam<String>
    public var currentArchitecture: String { return currentArchitectureParam.value }
    // "VALID_ARCHS": "i386 x86_64"
    public let validArchitectureParam: KeyValueParam<String>
    public var validArchitecture: String { return validArchitectureParam.value }
    // "arch": "x86_64",
    public let architectureParam: KeyValueParam<String>
    public var architecture: String { return architectureParam.value }
    // "ARCHS": "x86_64",
    public let architecturesParam: KeyValueParam<String>
    public var architectures: String { return architecturesParam.value }
    // "ONLY_ACTIVE_ARCH": "YES",
    public let onlyActiveArchitectureParam: KeyValueParam<Bool>
    public var onlyActiveArchitecture: Bool { return onlyActiveArchitectureParam.value }
    
    // "SDK_VERSION": "12.1"
    public let sdkVersionParam: KeyValueParam<String>
    public var sdkVersion: String { return sdkVersionParam.value }
    // "SDK_VERSION_ACTUAL": "120100"
    public let sdkActualVersionParam: KeyValueParam<String>
    public var sdkActualVersion: String { return sdkActualVersionParam.value }
    // "SDK_VERSION_MAJOR": "120000"
    public let sdkMajorVersionParam: KeyValueParam<String>
    public var sdkMajorVersion: String { return sdkMajorVersionParam.value }
    // "SDK_VERSION_MINOR": "100"
    public let sdkMinorVersionParam: KeyValueParam<String>
    public var sdkMinorVersion: String { return sdkMinorVersionParam.value }
    // "SDK_NAMES": "iphonesimulator12.1"
    public let sdkNamesParam: KeyValueParam<String>
    public var sdkNames: String { return sdkNamesParam.value }
    // "SWIFT_VERSION": "4.0"
    public let swiftVersionParam: KeyValueParam<String>
    public var swiftVersion: String { return swiftVersionParam.value }
    // "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule"
    public let swiftOptimizationLevelParam: KeyValueParam<String>
    public var swiftOptimizationLevel: String { return swiftOptimizationLevelParam.value }
    // "SWIFT_COMPILATION_MODE": "wholemodule"
    public let swiftCompilationModeParam: KeyValueParam<String>
    public var swiftCompilationMode: String { return swiftCompilationModeParam.value }
    // "PLATFORM_NAME": "iphonesimulator"
    public let platformNameParam: KeyValueParam<String>
    public var platformName: String { return platformNameParam.value }
    // "EFFECTIVE_PLATFORM_NAME": "iphonesimulator"
    public let effectivePlatformNameParam: KeyValueParam<String>
    public var effectivePlatformName: String { return effectivePlatformNameParam.value }
    // "SUPPORTED_PLATFORMS": "iphonesimulator iphoneos"
    public let supportedPlatformsParam: KeyValueParam<String>
    public var supportedPlatforms: String { return supportedPlatformsParam.value }
    // "CONFIGURATION": "Debug"
    public let configurationParam: KeyValueParam<String>
    public var configuration: String { return configurationParam.value }
    // "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
    public let debugInformationFormatParam: KeyValueParam<String>
    public var debugInformationFormat: String { return debugInformationFormatParam.value }
    
    // "XCODE_VERSION_ACTUAL": "1010"
    public let xcodeActualVersionParam: KeyValueParam<String>
    public var xcodeActualVersion: String { return xcodeActualVersionParam.value }
    // "XCODE_VERSION_MAJOR": "1000"
    public let xcodeMajorVersionParam: KeyValueParam<String>
    public var xcodeMajorVersion: String { return xcodeMajorVersionParam.value }
    // "XCODE_VERSION_MINOR": "1010"
    public let xcodeMinorVersionParam: KeyValueParam<String>
    public var xcodeMinorVersion: String { return xcodeMinorVersionParam.value }
    // "XCODE_PRODUCT_BUILD_VERSION": "10B61"
    public let xcodeProductBuildVersionParam: KeyValueParam<String>
    public var xcodeProductBuildVersion: String { return xcodeProductBuildVersionParam.value }
    // "COMMAND_MODE": "legacy"
    public let commandModeParam: KeyValueParam<String>
    public var commandMode: String { return commandModeParam.value }
    
    // "USER": "username"
    public let userParam: KeyValueParam<String>
    public var user: String { return userParam.value }
    
    // "PODS_CONFIGURATION_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let podsConfigurationBuildDirectoryParam: KeyValueParam<String>
    public var podsConfigurationBuildDirectory: String { return podsConfigurationBuildDirectoryParam.value }
    // "PODS_ROOT": "/b/Some/Pods"
    public let podsRootParam: KeyValueParam<String>
    public var podsRoot: String { return podsRootParam.value }
    
    public var podsProjectPath: String {
        let podsProjectFileName = "Pods.xcodeproj"
        let podsProjectPath = podsRoot + "/" + podsProjectFileName
        return podsProjectPath
    }
    
    public init(environment: [String: String] = ProcessInfo.processInfo.environment) throws {
        targetNameParam = try environment.getKeyValueParam("TARGETNAME")
        projectParam = try environment.getKeyValueParam("PROJECT")
        productBundleIdentifierParam = try environment.getKeyValueParam("PRODUCT_BUNDLE_IDENTIFIER")
        fullProductNameParam = try? environment.getKeyValueParam("FULL_PRODUCT_NAME")
        targetBuildDirectoryParam = try environment.getKeyValueParam("TARGET_BUILD_DIR")
        moduleCacheDirectoryParam = try environment.getKeyValueParam("MODULE_CACHE_DIR")
        projectTemporaryDirectoryParam = try environment.getKeyValueParam("PROJECT_TEMP_ROOT")
        dwarfDSYMFolderPathParam = try environment.getKeyValueParam("DWARF_DSYM_FOLDER_PATH")
        dwarfDsymFileNameParam = try environment.getKeyValueParam("DWARF_DSYM_FILE_NAME")
        developerFrameworksDirectoryQuotedParam = try environment.getKeyValueParam("DEVELOPER_FRAMEWORKS_DIR_QUOTED")
        objRootParam = try environment.getKeyValueParam("OBJROOT")
        buildDirectoryParam = try environment.getKeyValueParam("BUILD_DIR")
        configurationBuildDirectoryParam = try environment.getKeyValueParam("CONFIGURATION_BUILD_DIR")
        projectFilePathParam = try environment.getKeyValueParam("PROJECT_FILE_PATH")
        projectDirectoryParam = try environment.getKeyValueParam("PROJECT_DIR")
        sourceRootParam = try environment.getKeyValueParam("SRCROOT")
        
        userBinaryPathParam = try environment.getKeyValueParam("PATH")
        
        otherLDFlagsParam = try environment.getKeyValueParam("OTHER_LDFLAGS")
        otherSwiftFlagsParam = try environment.getKeyValueParam("OTHER_SWIFT_FLAGS")
        gccPreprocessorDefinitionsParam = try environment.getKeyValueParam("GCC_PREPROCESSOR_DEFINITIONS")
        
        enableBitcodeParam = try environment.getBoolKeyValueParam("ENABLE_BITCODE")
        enableTestabilityParam = try environment.getBoolKeyValueParam("ENABLE_TESTABILITY")
        profilingCodeParam = try environment.getBoolKeyValueParam("PROFILING_CODE")
        
        currentArchitectureParam = try environment.getKeyValueParam("CURRENT_ARCH")
        validArchitectureParam = try environment.getKeyValueParam("VALID_ARCHS")
        architectureParam = try environment.getKeyValueParam("arch")
        architecturesParam = try environment.getKeyValueParam("ARCHS")
        onlyActiveArchitectureParam = try environment.getBoolKeyValueParam("ONLY_ACTIVE_ARCH")
        
        sdkVersionParam = try environment.getKeyValueParam("SDK_VERSION")
        sdkActualVersionParam = try environment.getKeyValueParam("SDK_VERSION_ACTUAL")
        sdkMajorVersionParam = try environment.getKeyValueParam("SDK_VERSION_MAJOR")
        sdkMinorVersionParam = try environment.getKeyValueParam("SDK_VERSION_MINOR")
        sdkNamesParam = try environment.getKeyValueParam("SDK_NAMES")
        swiftVersionParam = try environment.getKeyValueParam("SWIFT_VERSION")
        swiftOptimizationLevelParam = try environment.getKeyValueParam("SWIFT_OPTIMIZATION_LEVEL")
        swiftCompilationModeParam = try environment.getKeyValueParam("SWIFT_COMPILATION_MODE")
        platformNameParam = try environment.getKeyValueParam("PLATFORM_NAME")
        effectivePlatformNameParam = try environment.getKeyValueParam("EFFECTIVE_PLATFORM_NAME")
        supportedPlatformsParam = try environment.getKeyValueParam("SUPPORTED_PLATFORMS")
        configurationParam = try environment.getKeyValueParam("CONFIGURATION")
        debugInformationFormatParam = try environment.getKeyValueParam("DEBUG_INFORMATION_FORMAT")
        
        xcodeActualVersionParam = try environment.getKeyValueParam("XCODE_VERSION_ACTUAL")
        xcodeMajorVersionParam = try environment.getKeyValueParam("XCODE_VERSION_MAJOR")
        xcodeMinorVersionParam = try environment.getKeyValueParam("XCODE_VERSION_MINOR")
        xcodeProductBuildVersionParam = try environment.getKeyValueParam("XCODE_PRODUCT_BUILD_VERSION")
        commandModeParam = try environment.getKeyValueParam("COMMAND_MODE")
        
        userParam = try environment.getKeyValueParam("USER")
        
        let podsConfigurationBuildDirectoryDefaultValue = "\(configurationBuildDirectoryParam.value)/\(effectivePlatformNameParam.value)"
        podsConfigurationBuildDirectoryParam = try environment.getKeyValueParam("PODS_CONFIGURATION_BUILD_DIR", defaultValue: podsConfigurationBuildDirectoryDefaultValue)
        let podsRootDefaultValue = "\(sourceRootParam.value)/Pods"
        podsRootParam = try environment.getKeyValueParam("PODS_ROOT", defaultValue: podsRootDefaultValue)
    }
    
}
