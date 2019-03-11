import Foundation
import XCTest
@testable import BuildParametersParser

public final class LinkerFlagParserTests: XCTestCase {
    
    let parser = LinkerFlagParser()
    
    // MARK: - Lifecycle
    
    func test_parsing() {
        let string = [" -ObjC -ObjC -l\"GoogleAnalytics\" -l\"c++\" -l\"resolv\" ",
                      "-l\"sqlite3\" -l\"stdc++\" -l\"xml2\" -l\"z\" -framework ",
                    "\"AVFoundation\" -framework \"Alamofire\" -framework \"AlamofireImage\"",
                    " -weak_framework \"SafariServices\" -weak_framework \"WebKit\" ",
                    "-force_load path/to/libA.a"].joined()
        
        let ldFlags = parser.parse(linkerFlags: string)
        
        let frameworks = ldFlags.compactMap { $0.framework?.name }
        let weakFrameworks = ldFlags.compactMap { $0.weakFramework?.name }
        let libraries = ldFlags.compactMap { $0.library?.name }
        let flags = ldFlags.compactMap { $0.flag?.name }
        let flagsWithValue = ldFlags.compactMap { $0.flagWithValue?.name }
        
        XCTAssertEqual(ldFlags.count, 15)
        XCTAssertEqual(frameworks.count, 3)
        XCTAssertEqual(frameworks.first, "AVFoundation")
        XCTAssertEqual(weakFrameworks.count, 2)
        XCTAssertEqual(weakFrameworks.first, "SafariServices")
        XCTAssertEqual(libraries.count, 7)
        XCTAssertEqual(libraries.last, "z")
        XCTAssertEqual(flags.count, 2)
        XCTAssertEqual(flags.first, "ObjC")
        XCTAssertEqual(flagsWithValue.count, 1)
        XCTAssertEqual(flagsWithValue.first, "force_load")
    }

}
