import Foundation

public protocol CommandRunner {
    var registry: CommandRegistry { get }
    
    func register(commands: [Command.Type])
    
    func run(config: CommandRunConfig) -> Int32
}
