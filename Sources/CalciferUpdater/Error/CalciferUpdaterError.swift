import Foundation

public enum CalciferUpdaterError: Error, CustomStringConvertible {
    case emptyCalciferUpdateConfig
    case failedToDownloadFile(url: URL)
    case failedToParseVersionFile(url: URL)
    case failedToExecuteInstall(error: String?)
    case failedToInstallBinary(url: URL)
    
    public var description: String {
        switch self {
        case .emptyCalciferUpdateConfig:
            return "Calcifer update config is empty"
        case let .failedToDownloadFile(url):
            return "Failed to download file at url \(url)"
        case let .failedToParseVersionFile(url):
            return "Failed to parse version file at url \(url)"
        case let .failedToExecuteInstall(error):
            return "Failed to execute install. Error: \(error ?? "-")"
        case let .failedToInstallBinary(url):
            return "Failed to install binary at url \(url)"
        }
    }
}
