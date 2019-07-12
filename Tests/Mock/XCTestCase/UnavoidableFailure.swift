import Foundation
import XCTest

public final class UnavoidableFailure {
    public static func fail(
        _ message: String = "",
        file: StaticString = #file,
        line: UInt = #line)
        -> Never
    {
        currentTestCase()?.continueAfterFailure = false
        XCTFail(message, file: file, line: line)
        NSException(name: UnavoidableFailureException, reason: message).raise()
        
        // To produce `Never` return value. Note that it will not be executed after
        // raising an exception on the previous line
        fatalError(message)
    }
    
    static let UnavoidableFailureException = NSExceptionName(rawValue: "UnavoidableFailureException")
    
    private init() {}
}
