import Foundation

public extension FileManager {
    func file(name: String) -> URL {
        let currentDirectory = currentDirectoryPath as NSString
        let filePath = currentDirectory.appendingPathComponent(name)
        return URL(fileURLWithPath:filePath)
    }
}
