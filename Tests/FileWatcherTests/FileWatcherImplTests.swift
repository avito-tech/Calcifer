import Foundation
import XCTest
import Toolkit
@testable import FileWatcher

public final class FileWatcherImplTests: XCTestCase {
    
    lazy var fileManager = FileManager.default
    
    // FSEvent doesn't work at tmp directory
    lazy var directory = fileManager.home()
        .appendingPathComponent(UUID().uuidString)
    
    override public func setUp() {
        super.setUp()
        try? fileManager.createDirectory(
            atPath: directory,
            withIntermediateDirectories: true
        )
    }
    
    override public func tearDown() {
        super.tearDown()
        try? fileManager.removeItem(
            atPath: directory
        )
    }
    
    func test_subscribe() {
        // Given
        let eventExpectation = expectation(description: "Expect event")
        let fileWatcher = FileWatcherImpl()
        var fileWatcherEvent: FileWatcherEvent?

        let filePath = directory
            .appendingPathComponent(UUID().uuidString)
        
        // When
        fileWatcher.subscribe { event in
            fileWatcherEvent = event
            eventExpectation.fulfill()
        }
        fileWatcher.start(path: filePath)
        let data = UUID().uuidString.data(using: .utf8)
        self.fileManager.createFile(
            atPath: filePath,
            contents: data
        )
        // Then
        waitForExpectations(timeout: 0.5) { _ in
            guard let event = fileWatcherEvent else {
                XCTFail("Failed receive event")
                return
            }
            XCTAssertEqual(
                event.path,
                filePath
            )
        }
    }
    
}
