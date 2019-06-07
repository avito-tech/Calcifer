import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import CalciferConfig
import ShellCommand
import Foundation
import Utility
import Toolkit

public final class UpdateCalciferCommand: Command {
    
    public let command = "updateCalcifer"
    public let overview = "Download and install new version of Calcifer if exist"
    
    enum Arguments: String, CommandArgument {
        case projectDirectory
    }
    
    private let projectDirectoryPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectDirectoryPathArgument = subparser.add(
            option: Arguments.projectDirectory.optionString,
            kind: String.self,
            usage: "Specify path to project directory for load config. (optional)"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        
        let projectDirectoryPath: String?
        if let projectDirectoryPathArgumentValue = arguments.get(self.projectDirectoryPathArgument) {
            projectDirectoryPath = projectDirectoryPathArgumentValue
        } else if let params = try? XcodeBuildEnvironmentParameters() {
            projectDirectoryPath = params.projectDirectory
        } else {
            projectDirectoryPath = nil
        }
        
        let fileManager = FileManager.default
        let configProvider = CalciferConfigProvider(fileManager: fileManager)
        
        let config: CalciferUpdateConfig
        if let projectDirectoryPath = projectDirectoryPath,
            let projectConfig = try? configProvider.obtainConfig(projectDirectoryPath: projectDirectoryPath),
            let updateConfig = projectConfig.calciferUpdateConfig
        {
            config = updateConfig
        } else {
            guard let shipConfig = try configProvider.obtainGlobalConfig().calciferUpdateConfig else {
                throw CalciferUpdaterError.emptyCalciferUpdateConfig
            }
            config = shipConfig
        }
        
        let shellExecutor = ShellCommandExecutorImpl()
        let updater = CalciferUpdaterImpl(
            session: URLSession.shared,
            fileManager: fileManager,
            calciferBinaryPath: fileManager.calciferBinaryPath(),
            shellExecutor: shellExecutor
        )
        
        try DispatchGroup().wait { dispatchGroup in
            try updater.updateCalcifer(config: config) { result in
                switch result {
                case .success:
                    Logger.verbose("Successfully update")
                case let .failure(error):
                    Logger.verbose("Failed to update with error \(error)")
                }
                dispatchGroup.leave()
            }
        }
    }
    
}
