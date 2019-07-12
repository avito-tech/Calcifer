import Foundation
import XCTest

public extension XCTestCase {
    var uuid: String {
        return UUID().uuidString
    }
}
