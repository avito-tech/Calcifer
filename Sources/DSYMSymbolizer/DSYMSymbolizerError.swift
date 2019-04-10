import Foundation

public enum DSYMSymbolizerError: Error, CustomStringConvertible {
    case unableToObtainSymbols(binaryPath: String, code: Int32, output: String?, error: String?)
    case emptyOutputSymbols(binaryPath: String, output: String?, error: String?)
    case emptyPathList(binaryPath: String)
    case unableToFindNewSourcePath(path: String, sourceRoot: String)
    case unableToObtainDWARFDumpUUID(path: String, code: Int32, output: String?, error: String?)
    case uuidMismatch(dsymPath: String, binaryPath: String)
    case multipleDWARFFileInDSYM(dsymPath: String)
    case unableToFindDWARFFileInDSYM(dsymPath: String)
    case unableToWritePlist(path: String, content: [String: String])
    case unableToFindBuildSourcePath(binaryPath: String)
    
    public var description: String {
        switch self {
        case let .unableToObtainSymbols(binaryPath, code, output, error):
            return """
                    Unable to obtain symbols code for \(binaryPath)
                    status code \(code)
                    output: \(output ?? "-")
                    error: \(error ?? "-")
            """
        case let .emptyOutputSymbols(binaryPath, output, error):
            return """
                Empty output symbols for \(binaryPath)
                output: \(output ?? "-")
                error: \(error ?? "-")
            """
        case let .emptyPathList(binaryPath):
            return "Empty path list from \(binaryPath)"
        case let .unableToFindNewSourcePath(path, sourceRoot):
            return "Unable to find new source path for path \(path) in source root: \(sourceRoot)"
        case let .unableToObtainDWARFDumpUUID(path, code, output, error):
            return """
            Unable to obtain DWARF dump UUID for \(path)
            status code \(code)
            output: \(output ?? "-")
            error: \(error ?? "-")
            """
        case let .uuidMismatch(dsymPath, binaryPath):
            return "UUID mismatch for \(binaryPath) dsym \(dsymPath)"
        case let .multipleDWARFFileInDSYM(dsymPath):
            return "Found more than one dwarf file in dsym \(dsymPath)"
        case let .unableToFindDWARFFileInDSYM(dsymPath):
            return "Unable to find dwarf file in dsym \(dsymPath)"
        case let .unableToWritePlist(path, content):
            return "Unable to write plist at path \(path) with content \(content)"
        case let .unableToFindBuildSourcePath(binaryPath):
            return "Unable to find build source path for binary path \(binaryPath)"
        }
    }
}
