import Foundation
import XCTest
@testable import BuildParametersParser

public final class LDFlagParserTests: XCTestCase {
    
    let parser = LinkerFlagParser()
    
    // MARK: - Lifecycle
    
    func test_parsing() {
        let string = [" -ObjC -ObjC -l\"GoogleAnalytics\" -l\"c++\" -l\"resolv\" ",
                      "-l\"sqlite3\" -l\"stdc++\" -l\"xml2\" -l\"z\" -framework ",
                    "\"AVFoundation\" -framework \"Alamofire\" -framework \"AlamofireImage\"",
                    " -weak_framework \"SafariServices\" -weak_framework \"WebKit\""].joined()
        
        let ldFlags = parser.parse(linkerFlags: string)
        
        let flags = ldFlags.compactMap { $0.flag?.name }
        let frameworks = ldFlags.compactMap { $0.framework?.name }
        let weakFrameworks = ldFlags.compactMap { $0.weakFramework?.name }
        let libraries = ldFlags.compactMap { $0.library?.name }
        
        XCTAssertEqual(ldFlags.count, 14)
        XCTAssertEqual(flags.count, 2)
        XCTAssertEqual(flags.first, "ObjC")
        XCTAssertEqual(frameworks.count, 3)
        XCTAssertEqual(frameworks.first, "AVFoundation")
        XCTAssertEqual(weakFrameworks.count, 2)
        XCTAssertEqual(weakFrameworks.first, "SafariServices")
        XCTAssertEqual(libraries.count, 7)
        XCTAssertEqual(libraries.last, "z")
    }

}
