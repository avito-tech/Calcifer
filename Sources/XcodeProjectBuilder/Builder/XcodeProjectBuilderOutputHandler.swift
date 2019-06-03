import Foundation

public protocol XcodeProjectBuilderOutputHandler {
    func setupFileWrite()
    func writeOutput(_ data: Data)
    func writeError(_ data: Data)
}
