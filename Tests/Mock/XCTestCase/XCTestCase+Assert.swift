import Foundation
import XCTest

public extension XCTestCase {
    @discardableResult
    func assertNoThrow<T>(body: () throws -> (T)) -> T? {
        do {
            return try body()
        } catch {
            XCTFail("Code was expected to not throw error but it threw: \(error)")
            return nil
        }
    }
}
