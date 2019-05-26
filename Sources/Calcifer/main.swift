import ArgumentsParser
import Foundation
import Darwin

func main() -> Int32 {
    let arguments = ProcessInfo.processInfo.arguments.dropFirst()
    let config = CommandRunConfig(arguments: Array(arguments))
    let runner = CommandRunnerBuilder().build()
    return runner.run(config: config)
}

let exitCode = main()
exit(exitCode)
