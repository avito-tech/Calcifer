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
    
    public func setup(buildLogDirectory: String?) throws {
        guard let buildLogDirectory = buildLogDirectory else {
            return
        }
        let logFilePath = buildLogFile(
            buildLogDirectory: buildLogDirectory
        ).path
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
    
    private func buildLogFile(buildLogDirectory: String) -> URL {
        try? fileManager.createDirectory(
            atPath: buildLogDirectory,
            withIntermediateDirectories: true
        )
        let logFilePath = buildLogDirectory
            .appendingPathComponent(Date().formattedString())
            .appending(".txt")
        let logFile = URL(fileURLWithPath: logFilePath)
        return logFile
    }
}
