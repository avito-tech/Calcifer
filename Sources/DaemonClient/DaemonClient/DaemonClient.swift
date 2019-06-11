import Foundation
import ArgumentsParser
import DaemonModels

public protocol DaemonClient {
    func sendToDaemon(commandRunConfig: CommandRunConfig) throws
}
