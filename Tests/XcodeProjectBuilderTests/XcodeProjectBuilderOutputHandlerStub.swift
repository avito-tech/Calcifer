import Foundation
@testable import XcodeProjectBuilder

final class XcodeProjectBuilderOutputHandlerStub: XcodeProjectBuilderOutputHandler {
    
    public init() {}
    
    public var onSetup: (() -> ())?
    func setup() throws {
        onSetup?()
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
