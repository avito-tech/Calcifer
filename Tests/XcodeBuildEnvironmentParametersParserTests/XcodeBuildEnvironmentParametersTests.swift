import Foundation
import XCTest
import Mock
@testable import XcodeBuildEnvironmentParametersParser

public final class XcodeBuildEnvironmentParametersTests: XCTestCase {
    
    // MARK: - Lifecycle
    
    func test_parameters_create() {
        XCTAssertNoThrow(try XcodeBuildEnvironmentParameters.forTests())
    }
    
}
