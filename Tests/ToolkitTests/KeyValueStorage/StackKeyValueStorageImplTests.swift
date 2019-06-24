import Foundation
import XCTest
import Toolkit

public final class StackKeyValueStorageImplTests: XCTestCase {
    
    let storage = StackKeyValueStorageImpl<String, String>()
    
    func test_addValue() {
        // Given
        let key = UUID().uuidString
        let value = UUID().uuidString
        storage.addValue(value, for: key)
        // When
        let resultValue = storage.obtain(for: key)
        let nextResult = storage.obtain(for: key)
        // Then
        XCTAssertEqual(
            value,
            resultValue
        )
        XCTAssertNil(nextResult)
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
