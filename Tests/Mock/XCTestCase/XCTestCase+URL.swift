import Foundation
import XCTest

public extension XCTestCase {
    func url(_ string: String, file: StaticString = #file, line: UInt = #line) -> URL {
        return URL(string: string)
            .unwrapOrFail(
                file: file,
                line: line
            )
    }
}
