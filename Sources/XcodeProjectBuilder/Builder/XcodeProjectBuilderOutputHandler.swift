import Foundation

public protocol XcodeProjectBuilderOutputHandler {
    func setup() throws
    func writeOutput(_ data: Data)
    func writeError(_ data: Data)
}
