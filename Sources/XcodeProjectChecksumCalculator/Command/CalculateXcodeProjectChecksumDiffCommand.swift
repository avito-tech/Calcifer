import ArgumentsParser
import Foundation
import SPMUtility
import Checksum
import Toolkit

public final class CalculateXcodeProjectChecksumDiffCommand: Command {
    
    public let command = "diff"
    public let overview = "Calculate diff for xcode project checksums"
    
    enum Arguments: String, CommandArgument {
        case firstChecksumPath
        case secondChecksumPath
    }
    
    private let firstChecksumPathArgument: OptionArgument<String>
    private let secondChecksumPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        firstChecksumPathArgument = subparser.add(
            option: Arguments.firstChecksumPath.optionString,
            kind: String.self,
            usage: "Specify first checksum path"
        )
        secondChecksumPathArgument = subparser.add(
            option: Arguments.secondChecksumPath.optionString,
            kind: String.self,
            usage: "Specify second checksum path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result, runner: CommandRunner) throws {
        let firstChecksumPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.firstChecksumPathArgument),
            name: Arguments.firstChecksumPath.rawValue
        )
        let secondChecksumPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.secondChecksumPathArgument),
            name: Arguments.secondChecksumPath.rawValue
        )
        let firstCodableChecksumNode = try obtainCodableChecksumNode(path: firstChecksumPath)
        let secondCodableChecksumNode = try obtainCodableChecksumNode(path: secondChecksumPath)
        let diff = CodableChecksumNodeDiff.diff(
            previousValue: firstCodableChecksumNode,
            newValue: secondCodableChecksumNode
        )
        diff.printLeafs()
    }
    
    private func obtainCodableChecksumNode(path: String) throws -> CodableChecksumNode<String> {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode(
            CodableChecksumNode<String>.self,
            from: data
        )
    }
}
