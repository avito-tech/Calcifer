import Foundation
import XCTest

@_silgen_name("_XCTCurrentTestCase")
public func _XCTCurrentTestCase() -> AnyObject?

public func currentTestCase() -> XCTestCase? {
    return _XCTCurrentTestCase() as? XCTestCase
}
