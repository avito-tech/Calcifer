import Foundation
import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import CalciferConfig
import SPMUtility
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
        
        let binaryPath = try obtainBinaryPath(with: arguments)
        
        let projectDirectoryPath = obtainProjectDirectory(with: arguments)
        
        let fileManager = FileManager.default
        let calciferPathProvider = CalciferPathProviderImpl(fileManager: fileManager)
        let configProvider = CalciferConfigProvider(
            calciferDirectory: calciferPathProvider.calciferDirectory()
        )

        let basicAccessAuthentication = obtainBasicAccessAuthentication(
            with: arguments,
            projectDirectory: projectDirectoryPath,
            configProvider: configProvider
        )
        
        let config = try obtainPatchedShipConfig(
            configProvider: configProvider,
            projectDirectory: projectDirectoryPath,
            basicAccessAuthentication: basicAccessAuthentication
        )
        
        let shipper = CalciferVersionShipperImpl(
            session: URLSession.shared,
            fileManager: fileManager
        )
        try ship(
            shipper: shipper,
            binaryPath: binaryPath,
            config: config
        )
    }
    
    private func ship(
        shipper: CalciferVersionShipper,
        binaryPath: String,
        config: CalciferShipConfig)
        throws
    {
        try DispatchGroup.wait { dispatchGroup in
            try shipper.shipCalcifer(at: binaryPath, config: config) { result in
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
    
    private func obtainPatchedShipConfig(
        configProvider: CalciferConfigProvider,
        projectDirectory: String?,
        basicAccessAuthentication: BasicAccessAuthentication?)
        throws -> CalciferShipConfig
    {
        let config = try obtainShipConfig(
            configProvider: configProvider,
            projectDirectory: projectDirectory
        )
        return CalciferShipConfig(
            versionFileURL: config.versionFileURL,
            zipBinaryFileURL: config.zipBinaryFileURL,
            basicAccessAuthentication: basicAccessAuthentication
        )
    }
    
    private func obtainShipConfig(
        configProvider: CalciferConfigProvider,
        projectDirectory: String?)
        throws -> CalciferShipConfig
    {
        if let projectDirectory = projectDirectory,
            let projectConfig = try? configProvider.obtainConfig(projectDirectoryPath: projectDirectory),
            let shipConfig = projectConfig.calciferShipConfig
        {
            return shipConfig
        }
        guard let shipConfig = try configProvider.obtainGlobalConfig().calciferShipConfig else {
            throw CalciferVersionShipperError.emptyCalciferShipConfig
        }
        return shipConfig
    }
    
    private func obtainProjectDirectory(with arguments: ArgumentParser.Result) -> String? {
        if let projectDirectoryPathArgumentValue = arguments.get(self.projectDirectoryPathArgument) {
            return projectDirectoryPathArgumentValue
        } else if let params = try? XcodeBuildEnvironmentParameters() {
            return params.projectDirectory
        }
        return nil
    }
    
    private func obtainBinaryPath(with arguments: ArgumentParser.Result) throws -> String {
        if let binaryPathArgumentValue = arguments.get(self.binaryPathArgument) {
            return binaryPathArgumentValue
        }
        guard let currentBinaryPath = ProcessInfo.processInfo.arguments.first else {
            throw ArgumentsError.argumentIsMissing(Arguments.binaryPath.rawValue)
        }
        return currentBinaryPath
    }
    
    private func obtainBasicAccessAuthentication(
        with arguments: ArgumentParser.Result,
        projectDirectory: String?,
        configProvider: CalciferConfigProvider)
        -> BasicAccessAuthentication?
    {
        if let login = arguments.get(self.loginArgument),
            let password = arguments.get(self.passwordArgument){
            return BasicAccessAuthentication(
                login: login,
                password: password
            )
        } else if let basicAccessAuthenticationFromConfig = obtainAccessAuthenticationFromConfig(
            projectDirectoryPath: projectDirectory,
            configProvider: configProvider)
        {
            return basicAccessAuthenticationFromConfig
        }
        return nil
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
