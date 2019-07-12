import Foundation
import XCTest

open class BaseTestCase: XCTestCase {
    
    public lazy var fileManager: FileManager = {
        return FileManager.default
    }()
    
    private lazy var temporaryDirectory: URL = {
        fileManager.temporaryDirectory
            .appendingPathComponent(uuid)
    }()
    
    override open func setUp() {
        super.setUp()
        assertNoThrow {
            try fileManager.createDirectory(
                at: temporaryDirectory,
                withIntermediateDirectories: true
            )
        }
    }
    
    override open func tearDown() {
        super.tearDown()
        assertNoThrow {
            try fileManager.removeItem(at: temporaryDirectory)
        }
    }
    
    public func createTmpDirectory(_ name: String = UUID().uuidString) -> URL {
        let directoryURL = temporaryDirectory
                .appendingPathComponent(name)
        assertNoThrow {
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true
            )
        }
        return directoryURL
    }
    
    public func createTmpFile(
        _ name: String = UUID().uuidString,
        at directoryName: String? = nil,
        data: Data? = nil)
        -> URL
    {
        let fileURL: URL
        if let directoryName = directoryName {
            fileURL = temporaryDirectory
                .appendingPathComponent(directoryName)
                .appendingPathComponent(name)
        } else {
            fileURL = temporaryDirectory.appendingPathComponent(name)
        }
        fileManager.createFile(
            atPath: fileURL.path,
            contents: data
        )
        return fileURL
    }
}
