import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import CalciferConfig
import Foundation
import Utility
import Toolkit

public final class ShipCurrentCalciferVersionCommand: Command {
    
    public let command = "shipCurrentCalciferVersion"
    public let overview = "Ship current calcifer binary and version file."
    
    enum Arguments: String, CommandArgument {
        case binaryPath
        case projectDirectoryPath
        case login
        case password
    }
    
    private let binaryPathArgument: OptionArgument<String>
    private let projectDirectoryPathArgument: OptionArgument<String>
    private let loginArgument: OptionArgument<String>
    private let passwordArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        binaryPathArgument = subparser.add(
            option: Arguments.binaryPath.optionString,
            kind: String.self,
            usage: "Specify binary path. By default current binary"
        )
        projectDirectoryPathArgument = subparser.add(
            option: Arguments.projectDirectoryPath.optionString,
            kind: String.self,
            usage: "Specify path to project directory for load config. (optional)"
        )
        loginArgument = subparser.add(
            option: Arguments.login.optionString,
            kind: String.self,
            usage: "Specify login for basic access authentication. By default get from config file. (optional)"
        )
        passwordArgument = subparser.add(
            option: Arguments.password.optionString,
            kind: String.self,
            usage: "Specify password for basic access authentication. By default get from config file. (optional)"
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
            binaryPath = currentBinaryPath
        }
        
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

        let basicAccessAuthentication: BasicAccessAuthentication?
        if let login = arguments.get(self.loginArgument),
            let password = arguments.get(self.passwordArgument){
            basicAccessAuthentication = BasicAccessAuthentication(
                login: login,
                password: password
            )
        } else if let basicAccessAuthenticationFromConfig = obtainAccessAuthenticationFromConfig(
            projectDirectoryPath: projectDirectoryPath,
            configProvider: configProvider)
        {
            basicAccessAuthentication = basicAccessAuthenticationFromConfig
        } else {
            basicAccessAuthentication = nil
        }
        
        let config: CalciferShipConfig
        if let projectDirectoryPath = projectDirectoryPath,
            let projectConfig = try? configProvider.obtainConfig(projectDirectoryPath: projectDirectoryPath),
            let shipConfig = projectConfig.calciferShipConfig
        {
            config = shipConfig
        } else {
            guard let shipConfig = try configProvider.obtainGlobalConfig().calciferShipConfig else {
                throw CalciferVersionShipperError.emptyCalciferShipConfig
            }
            config = shipConfig
        }
        
        let patchedCondig = CalciferShipConfig(
            versionFileURL: config.versionFileURL,
            zipBinaryFileURL: config.zipBinaryFileURL,
            basicAccessAuthentication: basicAccessAuthentication
        )
        
        let shipper = CalciferVersionShipperImpl(
            session: URLSession.shared,
            fileManager: fileManager
        )
        DispatchGroup().wait { dispatchGroup in
            shipper.shipCalcifer(at: binaryPath, config: patchedCondig) { result in
                switch result {
                case .success:
                    Logger.verbose("Successfully upload new version to \(config.zipBinaryFileURL)")
                case let .failure(error):
                    Logger.verbose("Failed to upload new version with error \(error)")
                }
                dispatchGroup.leave()
            }
        }
    }
    
    private func obtainAccessAuthenticationFromConfig(
        projectDirectoryPath: String?,
        configProvider: CalciferConfigProvider)
        -> BasicAccessAuthentication?
    {
        if let projectDirectoryPath = projectDirectoryPath,
            let config = try? configProvider.obtainConfig(projectDirectoryPath: projectDirectoryPath),
            let basicAccessAuthentication = basicAccessAuthentication(from: config)
        {
            return basicAccessAuthentication
        } else {
            guard let globalConfig = try? configProvider.obtainGlobalConfig(),
                let basicAccessAuthentication = basicAccessAuthentication(from: globalConfig)
                else { return nil }
            return basicAccessAuthentication
        }
    }
    
    private func basicAccessAuthentication(from config: CalciferConfig) -> BasicAccessAuthentication? {
        guard let basicAccessAuthentication = config.calciferShipConfig?.basicAccessAuthentication
            else { return nil }
        return basicAccessAuthentication
    }
    
}
