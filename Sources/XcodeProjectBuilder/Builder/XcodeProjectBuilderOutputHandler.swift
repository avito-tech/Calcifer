import Foundation

public protocol XcodeProjectBuilderOutputHandler {
    func setup(buildLogDirectory: String?) throws
    func writeOutput(_ data: Data)
    func writeError(_ data: Data)
}
