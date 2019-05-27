import Foundation
import XCTest
@testable import XcodeBuildEnvironmentParametersParser

public final class XcodeBuildEnvironmentParametersTests: XCTestCase {
    
    // MARK: - Lifecycle
    
    func test_parameters_create() {
        XCTAssertNoThrow(try XcodeBuildEnvironmentParameters(environment: environment()))
    }
    
    private func environment() -> [String: String] {
        // swiftlint:disable line_length
        return [
            "TARGETNAME": "Some",
            "PROJECT": "Some",
            "PRODUCT_IDENTIFIER": "io.some.bla",
            "PRODUCT_BUNDLE_IDENTIFIER": "io.some.bla",
            "FULL_PRODUCT_NAME": "Some.app",
            "TARGET_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator",
            "MODULE_CACHE_DIR": "/Users/admin/DD/ModuleCache.noindex",
            "PROJECT_TEMP_ROOT": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Intermediates.noindex",
            "DWARF_DSYM_FOLDER_PATH": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator",
            "DWARF_DSYM_FILE_NAME": "Some.app.dSYM",
            "DEVELOPER_FRAMEWORKS_DIR_QUOTED": "/Users/admin/Downloads/Xcode.app/Contents/Developer/Library/Frameworks",
            "OBJROOT": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Intermediates.noindex",
            "BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products",
            "CONFIGURATION_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator",
            "PROJECT_FILE_PATH": "/b/Some/Some.xcodeproj",
            "PROJECT_DIR": "/b/Some",
            "SRCROOT": "/b/Some",
            "PODS_CONFIGURATION_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator",
            "PODS_ROOT": "/b/Some/Pods",
            "PATH": "/usr/bin",
            "OTHER_LDFLAGS": " -ObjC -ObjC -l\"c++\" -l\"resolv\" -l\"sqlite3\" -l\"stdc++\" -l\"xml2\" -l\"z\" -framework \"AVFoundation\"",
            "OTHER_SWIFT_FLAGS": "-DDEBUG -Onone \"-D\" \"COCOAPODS\"",
            "GCC_PREPROCESSOR_DEFINITIONS": "Debug DEBUG=1 SWIFT_MODULE_Some COCOAPODS=1 Debug DEBUG=1 SWIFT_MO",
            "ENABLE_BITCODE": "NO",
            "ENABLE_TESTABILITY": "YES",
            "PROFILING_CODE": "NO",
            "CURRENT_ARCH": "x86_64",
            "VALID_ARCHS": "i386 x86_64",
            "arch": "x86_64",
            "ARCHS": "x86_64",
            "ONLY_ACTIVE_ARCH": "YES",
            "SDK_VERSION": "12.1",
            "SDK_VERSION_ACTUAL": "120100",
            "SDK_VERSION_MAJOR": "120000",
            "SDK_VERSION_MINOR": "100",
            "SDK_NAMES": "iphonesimulator12.1",
            "SWIFT_VERSION": "4.0",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "SWIFT_COMPILATION_MODE": "wholemodule",
            "PLATFORM_NAME": "iphonesimulator",
            "SUPPORTED_PLATFORMS": "iphonesimulator iphoneos",
            "CONFIGURATION": "Debug",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
            "XCODE_VERSION_ACTUAL": "1010",
            "XCODE_VERSION_MAJOR": "1000",
            "XCODE_VERSION_MINOR": "1010",
            "XCODE_PRODUCT_BUILD_VERSION": "10B61",
            "COMMAND_MODE": "legacy"
        ]
    }
    
}
