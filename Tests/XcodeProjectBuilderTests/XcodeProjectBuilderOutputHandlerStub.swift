import Foundation
@testable import XcodeProjectBuilder

public final class XcodeProjectBuilderOutputHandlerStub: XcodeProjectBuilderOutputHandler {
    
    public init() {}
    
    public var onSetup: ((String?) -> ())?
    public func setup(buildLogDirectory: String?) throws {
        onSetup?(buildLogDirectory)
    }
    
    public var onWriteOutput: ((Data) -> ())?
    public func writeOutput(_ data: Data) {
        onWriteOutput?(data)
    }
    
    public var onWriteError: ((Data) -> ())?
    public func writeError(_ data: Data) {
        onWriteError?(data)
    }
    
}
