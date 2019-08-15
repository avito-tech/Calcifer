import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import Foundation
import SPMUtility
import Toolkit

public final class ObtainConfigValueCommand: Command {
    
    public let command = "obtainConfigValue"
    public let overview = "Obtain value from merged CalciferConfig by key path"
    
    enum Arguments: String, CommandArgument {
        case projectDirectory
        case keyPath
    }
    
    private let projectDirectoryPathArgument: OptionArgument<String>
    private let keyPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        projectDirectoryPathArgument = subparser.add(
            option: Arguments.projectDirectory.optionString,
            kind: String.self,
            usage: "Specify path to project directory for load config. Will be used merged CalciferConfig. Can be obtained from Xcode build environment."
        )
        keyPathArgument = subparser.add(
            option: Arguments.keyPath.optionString,
            kind: String.self,
            usage: "Specify key path. Example: calciferUpdateConfig.versionFileURL"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        
        let projectDirectory = try obtainProjectDirectory(with: arguments)

        let keyPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.keyPathArgument),
            name: Arguments.keyPath.rawValue
        )
        
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let configProvider = CalciferConfigProvider(
            calciferDirectory: calciferPathProvider.calciferDirectory()
        )
        let config = try configProvider.obtainConfig(
            projectDirectoryPath: projectDirectory
        )
        let value = try obtainKeyPathValue(from: config, keyPath: keyPath)
        guard let data = value.data(using: .utf8) else {
            return
        }
        FileHandle.standardOutput.write(data)
    }
    
    func obtainKeyPathValue(from config: CalciferConfig, keyPath: String) throws -> String {
        let dictionary = try config.toDictionary()
        guard let value = (dictionary as NSDictionary).value(forKeyPath: keyPath) else {
            throw CalciferConfigError.emptyValueForKeyPath(
                keyPath: keyPath,
                dictionary: dictionary
            )
        }
        return "\(value)\n"
    }
    
    private func obtainProjectDirectory(with arguments: ArgumentParser.Result) throws -> String {
        if let projectDirectoryPathArgumentValue = arguments.get(self.projectDirectoryPathArgument) {
            return projectDirectoryPathArgumentValue
        } else if let params = try? XcodeBuildEnvironmentParameters() {
            return params.projectDirectory
        }
        do {
            _ = try XcodeBuildEnvironmentParameters()
        } catch let error {
            Logger.error(error.localizedDescription)
        }
        throw ArgumentsError.argumentIsMissing(Arguments.projectDirectory.rawValue)
    }
}
