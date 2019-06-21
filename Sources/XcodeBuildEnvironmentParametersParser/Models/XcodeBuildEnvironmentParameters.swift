import Foundation

public final class XcodeBuildEnvironmentParameters: Codable {
    // "TARGETNAME": "Some"
    public let targetName: String
    // "PROJECT": "Some"
    public let project: String
    // "PRODUCT_BUNDLE_IDENTIFIER": "io.some.bla"
    public let productBundleIdentifier: String
    // "FULL_PRODUCT_NAME": "Some.app"
    public let fullProductName: String
    // "TARGET_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let targetBuildDirectory: String
    // "MODULE_CACHE_DIR": "/Users/admin/DD/ModuleCache.noindex"
    public let moduleCacheDirectory: String
    // "PROJECT_TEMP_ROOT": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Intermediates.noindex"
    public let projectTemporaryDirectory: String
    // "DWARF_DSYM_FOLDER_PATH": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let dwarfDSYMFolderPath: String
    // "DWARF_DSYM_FILE_NAME": "Some.app.dSYM"
    public let dwarfDsymFileName: String
    // "DEVELOPER_FRAMEWORKS_DIR_QUOTED": "/Users/admin/Downloads/Xcode.app/Contents/Developer/Library/Frameworks"
    public let developerFrameworksDirectoryQuoted: String
    // "OBJROOT": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Intermediates.noindex"
    public let objRoot: String
    // "BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products"
    public let buildDirectory: String
    // "CONFIGURATION_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let configurationBuildDirectory: String
    // "PROJECT_FILE_PATH": "/b/Some/Some.xcodeproj"
    public let projectFilePath: String
    // "PROJECT_DIR": "/b/Some",
    public let projectDirectory: String
    // "SRCROOT": "/b/Some"
    public let sourceRoot: String
    
    // "PODS_CONFIGURATION_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let podsConfigurationBuildDirectory: String
    // "PODS_ROOT": "/b/Some/Pods"
    public let podsRoot: String
    
    // "PATH": "/usr/bin"
    public let userBinaryPath: String
    
    // "OTHER_LDFLAGS": " -ObjC -ObjC -l\"c++\" -l\"resolv\" -l\"sqlite3\" -l\"stdc++\" -l\"xml2\" -l\"z\" -framework \"AVFoundation\" ..."
    public let otherLDFlags: String
    // "OTHER_SWIFT_FLAGS": "-DDEBUG -Onone \"-D\" \"COCOAPODS\""
    public let otherSwiftFlags: String
    // "GCC_PREPROCESSOR_DEFINITIONS": "Debug DEBUG=1 SWIFT_MODULE_Some COCOAPODS=1 Debug DEBUG=1 SWIFT_MO
    public let gccPreprocessorDefinitions: String
    
    // "ENABLE_BITCODE": "NO",
    public let enableBitcode: Bool
    // "ENABLE_TESTABILITY": "YES",
    public let enableTestability: Bool
    // "PROFILING_CODE": "NO",
    public let profilingCode: Bool
    
    // "CURRENT_ARCH": "x86_64"
    public let currentArchitecture: String
    // "VALID_ARCHS": "i386 x86_64"
    public let validArchitecture: String
    // "arch": "x86_64",
    public let architecture: String
    // "ARCHS": "x86_64",
    public let architectures: String
    // "ONLY_ACTIVE_ARCH": "YES",
    public let onlyActiveArchitecture: Bool
    
    // "SDK_VERSION": "12.1"
    public let sdkVersion: String
    // "SDK_VERSION_ACTUAL": "120100"
    public let sdkActualVersion: String
    // "SDK_VERSION_MAJOR": "120000"
    public let sdkMajorVersion: String
    // "SDK_VERSION_MINOR": "100"
    public let sdkMinorVersion: String
    // "SDK_NAMES": "iphonesimulator12.1"
    public let sdkNames: String
    // "SWIFT_VERSION": "4.0"
    public let swiftVersion: String
    // "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule"
    public let swiftOptimizationLevel: String
    // "SWIFT_COMPILATION_MODE": "wholemodule"
    public let swiftCompilationMode: String
    // "PLATFORM_NAME": "iphonesimulator"
    public let platformName: String
    // "SUPPORTED_PLATFORMS": "iphonesimulator iphoneos"
    public let supportedPlatforms: String
    // "CONFIGURATION": "Debug"
    public let configuration: String
    // "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
    public let debugInformationFormat: String
    
    // "XCODE_VERSION_ACTUAL": "1010"
    public let xcodeActualVersion: String
    // "XCODE_VERSION_MAJOR": "1000"
    public let xcodeMajorVersion: String
    // "XCODE_VERSION_MINOR": "1010"
    public let xcodeMinorVersion: String
    // "XCODE_PRODUCT_BUILD_VERSION": "10B61"
    public let xcodeProductBuildVersion: String
    // "COMMAND_MODE": "legacy"
    public let commandMode: String
    
    // "USER": "username"
    public let user: String
    
    public var podsProjectPath: String {
        let podsProjectFileName = "Pods.xcodeproj"
        let podsProjectPath = podsRoot + "/" + podsProjectFileName
        return podsProjectPath
    }
    
    public init(environment: [String: String] = ProcessInfo.processInfo.environment) throws {
        targetName = try environment.getValue("TARGETNAME")
        project = try environment.getValue("PROJECT")
        productBundleIdentifier = try environment.getValue("PRODUCT_BUNDLE_IDENTIFIER")
        fullProductName = try environment.getValue("FULL_PRODUCT_NAME")
        targetBuildDirectory = try environment.getValue("TARGET_BUILD_DIR")
        moduleCacheDirectory = try environment.getValue("MODULE_CACHE_DIR")
        projectTemporaryDirectory = try environment.getValue("PROJECT_TEMP_ROOT")
        dwarfDSYMFolderPath = try environment.getValue("DWARF_DSYM_FOLDER_PATH")
        dwarfDsymFileName = try environment.getValue("DWARF_DSYM_FILE_NAME")
        developerFrameworksDirectoryQuoted = try environment.getValue("DEVELOPER_FRAMEWORKS_DIR_QUOTED")
        objRoot = try environment.getValue("OBJROOT")
        buildDirectory = try environment.getValue("BUILD_DIR")
        configurationBuildDirectory = try environment.getValue("CONFIGURATION_BUILD_DIR")
        projectFilePath = try environment.getValue("PROJECT_FILE_PATH")
        projectDirectory = try environment.getValue("PROJECT_DIR")
        sourceRoot = try environment.getValue("SRCROOT")
        
        podsConfigurationBuildDirectory = try environment.getValue("PODS_CONFIGURATION_BUILD_DIR")
        podsRoot = try environment.getValue("PODS_ROOT")
        
        userBinaryPath = try environment.getValue("PATH")
        
        otherLDFlags = try environment.getValue("OTHER_LDFLAGS")
        otherSwiftFlags = try environment.getValue("OTHER_SWIFT_FLAGS")
        gccPreprocessorDefinitions = try environment.getValue("GCC_PREPROCESSOR_DEFINITIONS")
        
        enableBitcode = try environment.getValue("ENABLE_BITCODE") == "YES"
        enableTestability = try environment.getValue("ENABLE_TESTABILITY") == "YES"
        profilingCode = try environment.getValue("PROFILING_CODE") == "YES"
        
        currentArchitecture = try environment.getValue("CURRENT_ARCH")
        validArchitecture = try environment.getValue("VALID_ARCHS")
        architecture = try environment.getValue("arch")
        architectures = try environment.getValue("ARCHS")
        onlyActiveArchitecture = try environment.getValue("ONLY_ACTIVE_ARCH") == "YES"
        
        sdkVersion = try environment.getValue("SDK_VERSION")
        sdkActualVersion = try environment.getValue("SDK_VERSION_ACTUAL")
        sdkMajorVersion = try environment.getValue("SDK_VERSION_MAJOR")
        sdkMinorVersion = try environment.getValue("SDK_VERSION_MINOR")
        sdkNames = try environment.getValue("SDK_NAMES")
        swiftVersion = try environment.getValue("SWIFT_VERSION")
        swiftOptimizationLevel = try environment.getValue("SWIFT_OPTIMIZATION_LEVEL")
        swiftCompilationMode = try environment.getValue("SWIFT_COMPILATION_MODE")
        platformName = try environment.getValue("PLATFORM_NAME")
        supportedPlatforms = try environment.getValue("SUPPORTED_PLATFORMS")
        configuration = try environment.getValue("CONFIGURATION")
        debugInformationFormat = try environment.getValue("DEBUG_INFORMATION_FORMAT")
        
        xcodeActualVersion = try environment.getValue("XCODE_VERSION_ACTUAL")
        xcodeMajorVersion = try environment.getValue("XCODE_VERSION_MAJOR")
        xcodeMinorVersion = try environment.getValue("XCODE_VERSION_MINOR")
        xcodeProductBuildVersion = try environment.getValue("XCODE_PRODUCT_BUILD_VERSION")
        commandMode = try environment.getValue("COMMAND_MODE")
        
        user = try environment.getValue("USER")
    }
}

extension Dictionary where Key: CustomStringConvertible {
    func getValue(_ key: Key) throws -> Value {
        guard let value = self[key] else {
            throw XcodeBuildEnvironmentParametersParserError.emptyBuildParameter(
                key: key.description
            )
        }
        return value
    }
}
