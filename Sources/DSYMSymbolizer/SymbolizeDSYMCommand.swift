import ArgumentsParser
import ShellCommand
import Foundation
import Utility
import Toolkit

public final class SymbolizeDSYMCommand: Command {
    
    public let command = "symbolizeDSYM"
    public let overview = "Change source path for dSYM"
    
    enum Arguments: String, CommandArgument {
        case dsymPath
        case binaryPath
        case sourcePath
    }
    
    private let dsymPathArgument: OptionArgument<String>
    private let binaryPathArgument: OptionArgument<String>
    private let sourcePathArgument: OptionArgument<String>
    
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
        sourcePathArgument = subparser.add(
            option: Arguments.sourcePath.optionString,
            kind: String.self,
            usage: "Specify source path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        let dsymPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.dsymPathArgument),
            name: Arguments.dsymPath.rawValue
        )
        let binaryPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.binaryPathArgument),
            name: Arguments.binaryPath.rawValue
        )
        let sourcePath = try ArgumentsReader.validateNotNil(
            arguments.get(self.sourcePathArgument),
            name: Arguments.sourcePath.rawValue
        )
        let shellCommandExecutor = ShellCommandExecutorImpl()
        let symbolizer = DSYMSymbolizer(
            symbolTableProvider: SymbolTableProviderImpl(shellCommandExecutor: shellCommandExecutor),
            dwarfUUIDProvider: DWARFUUIDProviderImpl(shellCommandExecutor: shellCommandExecutor),
            fileManager: FileManager.default
        )
        try symbolizer.symbolize(
            dsymPath: dsymPath,
            sourcePath: sourcePath,
            binaryPath: binaryPath
        )
    }
}
