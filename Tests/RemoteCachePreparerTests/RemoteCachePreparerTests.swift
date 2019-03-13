import Foundation
import XCTest
import XcodeBuildEnvironmentParametersParser
@testable import RemoteCachePreparer

public final class RemoteCachePreparerTests: XCTestCase {
    
    let parser = RemoteCachePreparer(fileManager: FileManager.default)
    
    // MARK: - Lifecycle
    
//    func test_prepare() {
//        XCTAssertNoThrow(try {
//            let params = try XcodeBuildEnvironmentParameters()
//            try parser.prepare(params: params)
//        }(), "Caught exception")
//    }

}
