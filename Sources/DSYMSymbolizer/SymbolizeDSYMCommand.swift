import ArgumentsParser
import ShellCommand
import Foundation
import SPMUtility
import Toolkit

public final class SymbolizeDSYMCommand: Command {
    
    public let command = "appendSourcePathMapToDSYM"
    public let overview = "Change source path for dSYM"
    
    enum Arguments: String, CommandArgument {
        case dsymPath
        case sourcePath
        case buildSourcePath
        case binaryPath
        case binaryPathInApp
    }
    
    private let dsymPathArgument: OptionArgument<String>
    private let binaryPathArgument: OptionArgument<String>
    private let binaryPathInAppArgument: OptionArgument<String>
    private let sourcePathArgument: OptionArgument<String>
    private let buildSourcePathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        dsymPathArgument = subparser.add(
            option: Arguments.dsymPath.optionString,
            kind: String.self,
            usage: "Specify dSYM path"
        )
        binaryPathArgument = subparser.add(
            option: Arguments.binaryPath.optionString,
            kind: String.self,
            usage: "Specify binary path"
        )
        binaryPathInAppArgument = subparser.add(
            option: Arguments.binaryPathInApp.optionString,
            kind: String.self,
            usage: "Specify binary path in app"
        )
        sourcePathArgument = subparser.add(
            option: Arguments.sourcePath.optionString,
            kind: String.self,
            usage: "Specify source path"
        )
        buildSourcePathArgument = subparser.add(
            option: Arguments.buildSourcePath.optionString,
            kind: String.self,
            usage: "Specify build source path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let dsymPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.dsymPathArgument),
            name: Arguments.dsymPath.rawValue
        )
        let sourcePath = try ArgumentsReader.validateNotNil(
            arguments.get(self.sourcePathArgument),
            name: Arguments.sourcePath.rawValue
        )
        let buildSourcePath = try ArgumentsReader.validateNotNil(
            arguments.get(self.buildSourcePathArgument),
            name: Arguments.buildSourcePath.rawValue
        )
        let binaryPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.binaryPathArgument),
            name: Arguments.binaryPath.rawValue
        )
        let binaryPathInApp = try ArgumentsReader.validateNotNil(
            arguments.get(self.binaryPathInAppArgument),
            name: Arguments.binaryPathInApp.rawValue
        )
        let shellCommandExecutor = ShellCommandExecutorImpl()
        let dwarfUUIDProvider = DWARFUUIDProviderImpl(
            shellCommandExecutor: shellCommandExecutor
        )
        let symbolizer = DSYMSymbolizer(
            dwarfUUIDProvider: dwarfUUIDProvider,
            fileManager: FileManager.default
        )
        try symbolizer.symbolize(
            dsymBundlePath: dsymPath,
            sourcePath: sourcePath,
            buildSourcePath: buildSourcePath,
            binaryPath: binaryPath,
            binaryPathInApp: binaryPathInApp
        )
    }
}
