import Foundation
import ArgumentsParser
import CommandRunner
import XcodeBuildEnvironmentParametersParser
import XcodeProjectChecksumCalculator
import RemoteCachePreparer
import XcodeProjectPatcher
import XcodeProjectBuilder
import BuildStepIntegrator
import DSYMSymbolizer
import Daemon
import CalciferVersionShipper
import CalciferUpdater

final class CommandRunnerBuilder {
    
    init() {}
    
    func build() -> CommandRunner {
        let runner = CommandRunnerImpl()
        runner.register(
            commands: [
                PrepareRemoteCacheCommand.self,
                UploadRemoteCacheCommand.self,
                ParseXcodeBuildEnvironmentParametersCommand.self,
                CalculateXcodeProjectChecksumCommand.self,
                CalculateXcodeProjectChecksumDiffCommand.self,
                BuildXcodeProjectCommand.self,
                PatchXcodeProjectCommand.self,
                SymbolizeDSYMCommand.self,
                BuildStepIntegrateCommand.self,
                StartDaemonCommand.self,
                DaemonizeCommand.self,
                ShipCurrentCalciferVersionCommand.self,
                UpdateCalciferCommand.self
            ]
        )
        return runner
    }
}
