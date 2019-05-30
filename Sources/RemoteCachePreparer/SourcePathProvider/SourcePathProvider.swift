import Foundation

public protocol SourcePathProvider {
    func obtainSourcePath(podsRoot: String) throws -> String
}
