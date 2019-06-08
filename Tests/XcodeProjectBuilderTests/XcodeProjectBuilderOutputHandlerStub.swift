import Foundation
@testable import XcodeProjectBuilder

final class XcodeProjectBuilderOutputHandlerStub: XcodeProjectBuilderOutputHandler {
    
    public init() {}
    
    public var onSetup: ((String?) -> ())?
    func setup(buildLogDirectory: String?) throws {
        onSetup?(buildLogDirectory)
    }
    
    public var onWriteOutput: ((Data) -> ())?
    func writeOutput(_ data: Data) {
        onWriteOutput?(data)
    }
    
    public var onWriteError: ((Data) -> ())?
    func writeError(_ data: Data) {
        onWriteError?(data)
    }
    
}
