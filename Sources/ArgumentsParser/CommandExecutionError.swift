import Foundation

public enum CommandExecutionError: Error, CustomStringConvertible {
    
    case incorrectUsage(usageDescription: String)
    case unableGenerateDescription
    
    public var description: String {
        switch self {
        case .incorrectUsage(let usageDescription):
            return "Incorrect arguments. Usage:\n\(usageDescription)"
        case .unableGenerateDescription:
            return "Unable to generate description of usage"
        }
    }
}
