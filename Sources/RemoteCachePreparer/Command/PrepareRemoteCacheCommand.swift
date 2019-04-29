import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import Foundation
import ShellCommand
import Utility
import Toolkit

public final class PrepareRemoteCacheCommand: Command {
    
    public let command = "prepareRemoteCache"
    public let overview = "Prepare remote cache"
    
    enum Arguments: String, CommandArgument {
        case sourcePath
        case environmentFilePath
        case uploadCache
    }
    
    private let environmentFilePathArgument: OptionArgument<String>
    private let sourcePathArgument: OptionArgument<String>
    private let uploadCacheArgument: OptionArgument<Bool>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        sourcePathArgument = subparser.add(
            option: Arguments.sourcePath.optionString,
            kind: String.self,
            usage: "Specify source path"
        )
        environmentFilePathArgument = subparser.add(
            option: Arguments.environmentFilePath.optionString,
            kind: String.self,
            usage: "Specify environment file path"
        )
        uploadCacheArgument = subparser.add(
            option: Arguments.uploadCache.optionString,
            kind: Bool.self,
            usage: "Should upload cache"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        
        let sourcePath: String
        if let sourcePathArgumentValue = arguments.get(self.sourcePathArgument) {
            sourcePath = sourcePathArgumentValue
        } else {
            sourcePath = try obtainSourcePath()
        }
        
        let params: XcodeBuildEnvironmentParameters = try TimeProfiler.measure(
            "Parse environment parameters"
        ) {
            if let environmentFilePath = arguments.get(self.environmentFilePathArgument) {
                let data = try Data(contentsOf: URL(fileURLWithPath: environmentFilePath))
                return try JSONDecoder().decode(XcodeBuildEnvironmentParameters.self, from: data)
            } else {
                return try XcodeBuildEnvironmentParameters()
            }
        }
        
        let uploadCache: Bool
        if let uploadCacheArgumentValue = arguments.get(self.uploadCacheArgument) {
            uploadCache = uploadCacheArgumentValue
        } else {
            uploadCache = false
        }
        
        let preparer = RemoteCachePreparer(fileManager: FileManager.default)
        
        try TimeProfiler.measure("Prepare remote cache") {
            try preparer.prepare(
                params: params,
                sourcePath: sourcePath,
                uploadCache: uploadCache
            )
        }
    }
    
    private func obtainSourcePath() throws -> String {
        let command = ShellCommand(
            launchPath: "/usr/bin/git",
            arguments: [
                "rev-parse",
                "--show-toplevel"
            ],
            environment: [:]
        )
        let shellCommandExecutor = ShellCommandExecutorImpl()
        let result = shellCommandExecutor.execute(command: command)
        guard let output = result.output,
            result.terminationStatus == 0
            else
        {
            throw RemoteCachePreparerError.unableToObtainSourcePath
        }
        // Remove trailing new line
        return output.chop()
    }
}
