import Foundation

public extension FileManager {
    func file(name: String) -> URL {
        let directory: String
        if #available(OSX 10.12, *) {
            directory = homeDirectoryForCurrentUser.path
        } else {
            directory = currentDirectoryPath
        }
        return file(name: name, at: directory)
    }
    
    func file(name: String, at directory: String) -> URL {
        let filePath = (directory as NSString).appendingPathComponent(name)
        return URL(fileURLWithPath: filePath)
    }
}
