import ArgumentsParser
import Foundation
import Utility
import Toolkit

public final class ProjectChecksumDiffCommand: Command {
    
    public let command = "diff"
    public let overview = "Calculate diff for checksums"
    
    enum Arguments: String {
        case firstChecksumPath
        case secondChecksumPath
    }
    
    private let firstChecksumPathArgument: OptionArgument<String>
    private let secondChecksumPathArgument: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        firstChecksumPathArgument = subparser.add(
            option: "--\(Arguments.firstChecksumPath.rawValue)",
            kind: String.self,
            usage: "Specify first checksum path"
        )
        secondChecksumPathArgument = subparser.add(
            option: "--\(Arguments.secondChecksumPath.rawValue)",
            kind: String.self,
            usage: "Specify second checksum path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        let firstChecksumPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.firstChecksumPathArgument),
            name: Arguments.firstChecksumPath.rawValue
        )
        let secondChecksumPath = try ArgumentsReader.validateNotNil(
            arguments.get(self.secondChecksumPathArgument),
            name: Arguments.secondChecksumPath.rawValue
        )
        let firstChecksumHolder = try projectChecksumHolder(path: firstChecksumPath)
        let secondChecksumHolder = try projectChecksumHolder(path: secondChecksumPath)
        
        if let diff = firstChecksumHolder.node().diff(became: secondChecksumHolder.node()) {
            diff.printTree()
        } else {
            print("Empty diff")
        }
    }
    
//    private func calculateTargetsDiff(diff: Diff<XcodeProjChecksumHolder<BaseChecksum>>) -> [Diff<TargetChecksumHolder<BaseChecksum>>] {
//        var allTarget = [String]()
//        let wasTargets = Dictionary(uniqueKeysWithValues:
//            diff.was?.proj.projects.flatMap({ $0.targets }).map({ ($0.name, $0) }) ?? []
//        )
//        wasTargets.keys.forEach {
//            if !allTarget.contains($0) {
//                allTarget.append($0)
//            }
//        }
//        let becameTargets = Dictionary(uniqueKeysWithValues:
//            diff.became?.proj.projects.flatMap({ $0.targets }).map({ ($0.name, $0) }) ?? []
//        )
//        becameTargets.keys.forEach {
//            if !allTarget.contains($0) {
//                allTarget.append($0)
//            }
//        }
//        return allTarget.compactMap({
//            Diff(
//                was: wasTargets[$0],
//                became: becameTargets[$0]
//            )
//        })
//    }
    
    private func projectChecksumHolder(path: String) throws -> XcodeProjChecksumHolder<BaseChecksum> {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        return try JSONDecoder().decode(
            XcodeProjChecksumHolder<BaseChecksum>.self,
            from: data
        )
    }
}
