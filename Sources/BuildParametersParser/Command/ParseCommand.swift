import ArgumentsParser
import Foundation
import Utility
import Toolkit

public final class ParseCommand: Command {
    
    public let command = "parse"
    public let overview = "Parse build prameters from environment"
    
    public required init(parser: ArgumentParser) {
        parser.add(subparser: command, overview: overview)
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        
        let params = try BuildParameters()
        let ldFlags = LDFlagParser().parse(ldFlagsString: params.otherLDFlags)
        let frameworks = ldFlags.compactMap({ $0.framework?.name })
        
        let outputFilePath = FileManager.default.file(name: "environment.txt")
        try "\(frameworks)".description.write(to: outputFilePath, atomically: false, encoding: .utf8)
        print(outputFilePath)
    }
    
}
