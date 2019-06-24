import Foundation
import XCTest
import Toolkit

public final class BaseKeyValueStorageTests: XCTestCase {
    
    var storage = BaseKeyValueStorage<String, String>()
    
    override public func setUp() {
        super.setUp()
        storage = BaseKeyValueStorage<String, String>()
    }
    
    func test_addValue() {
        // Given
        let key = UUID().uuidString
        let value = UUID().uuidString
        storage.addValue(value, for: key)
        // When
        let resultValue = storage.obtain(for: key)
        // Then
        XCTAssertEqual(
            value,
            resultValue
        )
    }
    
    func test_readEmpty() {
        // Given
        let key = UUID().uuidString
        // When
        let resultValue = storage.obtain(for: key)
        // Then
        XCTAssertNil(resultValue)
    }
    
}
