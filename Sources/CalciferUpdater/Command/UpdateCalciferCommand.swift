import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import CalciferConfig
import ShellCommand
import SPMUtility
import Toolkit

public final class UpdateCalciferCommand: Command {
    
    public let command = "updateCalcifer"
    public let overview = "Download and install new version of Calcifer if new version is available"
    
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
        
        let projectDirectoryPath = obtainProjectDirectory(with: arguments)
        
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let configProvider = CalciferConfigProvider(
            calciferDirectory: calciferPathProvider.calciferDirectory()
        )
        
        let updateConfig = try obtainUpdateConfig(
            configProvider: configProvider,
            projectDirectory: projectDirectoryPath
        )

        let updater = createCalciferUpdater(
            calciferPathProvider: calciferPathProvider,
            fileManager: fileManager
        )
        
        update(
            updater: updater,
            updateConfig: updateConfig
        )
    }
    
    private func createCalciferUpdater(
        calciferPathProvider: CalciferPathProvider,
        fileManager: FileManager)
        -> CalciferUpdater
    {
        let shellExecutor = ShellCommandExecutorImpl()
        let calciferBinaryPath = calciferPathProvider.calciferBinaryPath()
        let fileDownloader = FileDownloaderImpl(session: URLSession.shared)
        let updateChecker = UpdateCheckerImpl(
            fileDownloader: fileDownloader,
            fileManager: fileManager,
            calciferBinaryPath: calciferBinaryPath
        )
        return CalciferUpdaterImpl(
            updateChecker: updateChecker,
            fileDownloader: fileDownloader,
            fileManager: fileManager,
            calciferBinaryPath: calciferBinaryPath,
            shellExecutor: shellExecutor
        )
    }
    
    private func update(updater: CalciferUpdater, updateConfig: CalciferUpdateConfig) {
        DispatchGroup.wait { dispatchGroup in
            updater.updateCalcifer(config: updateConfig) { result in
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
    
    private func obtainProjectDirectory(with arguments: ArgumentParser.Result) -> String? {
        if let projectDirectoryPathArgumentValue = arguments.get(self.projectDirectoryPathArgument) {
            return projectDirectoryPathArgumentValue
        } else if let params = try? XcodeBuildEnvironmentParameters() {
            return params.projectDirectory
        }
        return nil
    }
    
    private func obtainUpdateConfig(
        configProvider: CalciferConfigProvider,
        projectDirectory: String?)
        throws -> CalciferUpdateConfig
    {
        if let projectDirectory = projectDirectory,
            let projectConfig = try? configProvider.obtainConfig(projectDirectoryPath: projectDirectory),
            let updateConfig = projectConfig.calciferUpdateConfig
        {
            return updateConfig
        }
        guard let updateConfig = try configProvider.obtainGlobalConfig().calciferUpdateConfig else {
            throw CalciferUpdaterError.emptyCalciferUpdateConfig
        }
        return updateConfig
    }
    
}
