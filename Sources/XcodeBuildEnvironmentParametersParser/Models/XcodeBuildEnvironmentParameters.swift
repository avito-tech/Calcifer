import Foundation

public final class XcodeBuildEnvironmentParameters {
    // "TARGETNAME": "Some"
    public let targetName: String
    // "FULL_PRODUCT_NAME": "Some.app"
    public let fullProductName: String
    // "TARGET_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let targetBuildDirectory: String
    // "DWARF_DSYM_FOLDER_PATH": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator"
    public let dwarfDSYMFolderPath: String
    // "DWARF_DSYM_FILE_NAME": "Some.app.dSYM"
    public let dwarfDsymFileName: String
    // "DEVELOPER_FRAMEWORKS_DIR_QUOTED": "/Users/admin/Downloads/Xcode.app/Contents/Developer/Library/Frameworks"
    public let developerFrameworksDirectoryQuoted: String
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
    // "SDK_NAMES": "iphonesimulator12.1"
    public let sdkNames: String
    // "SWIFT_VERSION": "4.0"
    public let swiftVersion: String
    // "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule"
    public let swiftOptimizationLevel: String
    // "PLATFORM_NAME": "iphonesimulator"
    public let platformName: String
    // "CONFIGURATION": "Debug"
    public let configuration: String
    // "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
    public let debugInformationFormat: String
    
    public init(environment: [String : String] = ProcessInfo.processInfo.environment) throws {
        targetName = try environment.getValue("TARGETNAME")
        fullProductName = try environment.getValue("FULL_PRODUCT_NAME")
        targetBuildDirectory = try environment.getValue("TARGET_BUILD_DIR")
        dwarfDSYMFolderPath = try environment.getValue("DWARF_DSYM_FOLDER_PATH")
        dwarfDsymFileName = try environment.getValue("DWARF_DSYM_FILE_NAME")
        developerFrameworksDirectoryQuoted = try environment.getValue("DEVELOPER_FRAMEWORKS_DIR_QUOTED")
        configurationBuildDirectory = try environment.getValue("CONFIGURATION_BUILD_DIR")
        projectFilePath = try environment.getValue("PROJECT_FILE_PATH")
        projectDirectory = try environment.getValue("PROJECT_DIR")
        sourceRoot = try environment.getValue("SRCROOT")
        
        podsConfigurationBuildDirectory = try environment.getValue("PODS_CONFIGURATION_BUILD_DIR")
        podsRoot = try environment.getValue("PODS_ROOT")
        
        otherLDFlags = try environment.getValue("OTHER_LDFLAGS")
        otherSwiftFlags = try environment.getValue("OTHER_SWIFT_FLAGS")
        gccPreprocessorDefinitions = try environment.getValue("GCC_PREPROCESSOR_DEFINITIONS")
        
        enableBitcode = try environment.getValue("ENABLE_BITCODE") == "YES"
        enableTestability = try environment.getValue("ENABLE_TESTABILITY") == "YES"
        
        currentArchitecture = try environment.getValue("CURRENT_ARCH")
        validArchitecture = try environment.getValue("VALID_ARCHS")
        architecture = try environment.getValue("arch")
        architectures = try environment.getValue("ARCHS")
        onlyActiveArchitecture = try environment.getValue("ONLY_ACTIVE_ARCH") == "YES"
        
        
        sdkVersion = try environment.getValue("SDK_VERSION")
        sdkNames = try environment.getValue("SDK_NAMES")
        swiftVersion = try environment.getValue("SWIFT_VERSION")
        swiftOptimizationLevel = try environment.getValue("SWIFT_OPTIMIZATION_LEVEL")
        platformName = try environment.getValue("PLATFORM_NAME")
        configuration = try environment.getValue("CONFIGURATION")
        debugInformationFormat = try environment.getValue("DEBUG_INFORMATION_FORMAT")
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
