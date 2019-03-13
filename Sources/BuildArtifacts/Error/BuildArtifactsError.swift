import Foundation

public enum BuildArtifactsError: Error, CustomStringConvertible {
    case productDirectoryDoesntExist(targetName: String, path: String)
    case frameworkDoesntExist(productName: String, path: String)
    case dsymDoesntExist(productName: String, path: String)
    
    public var description: String {
        switch self {
        case let .productDirectoryDoesntExist(targetName, path):
            return "Directory for target \(targetName) doesn't exist at \(path)"
        case let .frameworkDoesntExist(productName, path):
            return "Framework for product \(productName) doesn't exist at \(path)"
        case let .dsymDoesntExist(productName, path):
            return "dSYM for product \(productName) doesn't exist at \(path)"
        }
    }
}
