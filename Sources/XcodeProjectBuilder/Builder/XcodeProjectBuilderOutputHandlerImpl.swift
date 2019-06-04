import Foundation
import Toolkit

public final class XcodeProjectBuilderOutputHandlerImpl: XcodeProjectBuilderOutputHandler {
    
    private let fileManager: FileManager
    private let observableStandardStream: ObservableStandardStream
    private let outputFilter: XcodeProjectBuilderOutputFilter
    private var fileHandle: FileHandle? = nil
    
    public init(
        fileManager: FileManager,
        observableStandardStream: ObservableStandardStream,
        outputFilter: XcodeProjectBuilderOutputFilter)
    {
        self.fileManager = fileManager
        self.observableStandardStream = observableStandardStream
        self.outputFilter = outputFilter
    }
    
    public func setup() throws {
        let logFilePath = buildLogFile().path
        fileManager.createFile(atPath: logFilePath, contents: nil)
        guard let fileHandle = FileHandle(forWritingAtPath: logFilePath) else {
            throw XcodeProjectBuilderError.failedCreateBuildLogFile(path: logFilePath)
        }
        self.fileHandle = fileHandle
    }
    
    public func writeOutput(_ data: Data) {
        fileHandle?.write(data)
        guard let filtredData = outputFilter.filter(data: data) else { return }
        observableStandardStream.writeOutput(filtredData)
    }
    
    public func writeError(_ data: Data) {
        fileHandle?.write(data)
        guard let filtredData = outputFilter.filter(data: data) else { return }
        observableStandardStream.writeError(filtredData)
    }
    
    private func buildLogFile() -> URL {
        let fileManager = FileManager.default
        let logDirectory = fileManager.calciferDirectory()
            .appendingPathComponent("buildlogs")
        try? fileManager.createDirectory(
            atPath: logDirectory,
            withIntermediateDirectories: true
        )
        let logFilePath = logDirectory
            .appendingPathComponent(Date().formattedString())
            .appending(".txt")
        let logFile = URL(fileURLWithPath: logFilePath)
        return logFile
    }
}
