import Foundation

public protocol ShellCommand: CustomStringConvertible {
    var launchPath: String { get }
    var arguments: [String] { get }
    var environment: [String: String] { get }
}

public extension CustomStringConvertible where Self: ShellCommand{
    
    var description: String {
        return "\(launchPath) \(arguments.joined(separator: " "))"
    }
    
}
