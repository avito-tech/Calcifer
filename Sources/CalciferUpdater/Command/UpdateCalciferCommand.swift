import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import CalciferConfig
import Foundation
import Utility
import Toolkit

public final class UpdateCalciferCommand: Command {
    
    public let command = "updateCalcifer"
    public let overview = "Download and install new version of Calcifer if exist"
    
    enum Arguments: String, CommandArgument {
        case binaryPath
        case projectDirectory
    }
    
    private let binaryPathArgument: OptionArgument<String>
    private let projectDirectoryPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        binaryPathArgument = subparser.add(
            option: Arguments.binaryPath.optionString,
            kind: String.self,
            usage: "Specify binary path. By default current binary"
        )
        projectDirectoryPathArgument = subparser.add(
            option: Arguments.projectDirectory.optionString,
            kind: String.self,
            usage: "Specify path to project directory for load config. (optional)"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let binaryPath: String
        if let binaryPathArgumentValue = arguments.get(self.binaryPathArgument) {
            binaryPath = binaryPathArgumentValue
        } else {
            guard let currentBinaryPath = ProcessInfo.processInfo.arguments.first else {
                throw ArgumentsError.argumentIsMissing(Arguments.binaryPath.rawValue)
            }
        }
        
        let fileManager = FileManager.default
        let configProvider = CalciferConfigProvider(fileManager: fileManager)
        let params = try? XcodeBuildEnvironmentParameters()
    }
    
}
