import Foundation
import XCTest
@testable import XcodeBuildEnvironmentParametersParser

public final class XcodeBuildEnvironmentParametersTests: XCTestCase {
    
    // MARK: - Lifecycle
    
    func test_parameters_create() {
        XCTAssertNoThrow(try XcodeBuildEnvironmentParameters(environment: environment()))
    }
    
    private func environment() -> [String: String] {
        return [
            "TARGETNAME": "Some",
            "FULL_PRODUCT_NAME": "Some.app",
            "TARGET_BUILD_DIR": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator",
            "DWARF_DSYM_FOLDER_PATH": "/Users/admin/DD/Some-hjxzoeotbbmukebnmtngisnnfoef/Build/Products/Debug-iphonesimulator",
            "DWARF_DSYM_FILE_NAME": "Some.app.dSYM",
            "DEVELOPER_FRAMEWORKS_DIR_QUOTED": "/Users/admin/Downloads/Xcode.app/Contents/Developer/Library/Frameworks",
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
            "CURRENT_ARCH": "x86_64",
            "VALID_ARCHS": "i386 x86_64",
            "arch": "x86_64",
            "ARCHS": "x86_64",
            "ONLY_ACTIVE_ARCH": "YES",
            "SDK_VERSION": "12.1",
            "SDK_NAMES": "iphonesimulator12.1",
            "SWIFT_VERSION": "4.0",
            "SWIFT_OPTIMIZATION_LEVEL": "-Owholemodule",
            "PLATFORM_NAME": "iphonesimulator",
            "CONFIGURATION": "Debug",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
        ]
    }
    
}
