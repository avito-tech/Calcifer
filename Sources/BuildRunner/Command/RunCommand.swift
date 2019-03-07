import ArgumentsParser
import Foundation
import Utility

public final class RunCommand: Command {
    
    public let command = "run"
    public let overview = "Run build project"
    
    public required init(parser: ArgumentParser) {
        parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        try BuildRunner().run()
    }
}
