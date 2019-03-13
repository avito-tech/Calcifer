import XcodeBuildEnvironmentParametersParser
import ArgumentsParser
import Foundation
import Utility
import Toolkit

public final class PrepareRemoteCacheCommand: Command {
    
    public let command = "prepareRemoteCache"
    public let overview = "Prepare remote cache"
    
    enum Arguments: String, CommandArgument {
        case environmentFilePath
    }
    
    private let environmentFilePath: OptionArgument<String>
    
    public required init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, overview: overview)
        environmentFilePath = subparser.add(
            option: Arguments.environmentFilePath.optionString,
            kind: String.self,
            usage: "Specify environment file path"
        )
    }
    
    public func run(with arguments: ArgumentParser.Result) throws {
        let params: XcodeBuildEnvironmentParameters
        if let environmentFilePath = arguments.get(self.environmentFilePath) {
            let data = try Data(contentsOf: URL(fileURLWithPath: environmentFilePath))
            params = try JSONDecoder().decode(XcodeBuildEnvironmentParameters.self, from: data)
        } else {
            params = try XcodeBuildEnvironmentParameters()
        }
        
        let preparer = RemoteCachePreparer(fileManager: FileManager.default)
        try preparer.prepare(params: params)
    }
}
