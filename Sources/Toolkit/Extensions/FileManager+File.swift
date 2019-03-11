import Foundation

public extension FileManager {
    func pathToHomeDirectoryFile(name: String) -> URL {
        let directory: String
        if #available(OSX 10.12, *) {
            directory = homeDirectoryForCurrentUser.path
        } else {
            directory = NSHomeDirectory()
        }
        return file(name: name, at: directory)
    }
    
    func file(name: String, at directoryPath: String) -> URL {
        let filePath = (directoryPath as NSString).appendingPathComponent(name)
        return URL(fileURLWithPath: filePath)
    }
}
