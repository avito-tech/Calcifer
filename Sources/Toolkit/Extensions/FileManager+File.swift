import Foundation

public extension FileManager {
    func pathToHomeDirectoryFile(name: String) -> URL {
        return file(name: name, at: home())
    }
    
    func file(name: String, at directoryPath: String) -> URL {
        let filePath = directoryPath.appendingPathComponent(name)
        return URL(fileURLWithPath: filePath)
    }
    
    func home() -> String {
        if #available(OSX 10.12, *) {
            return homeDirectoryForCurrentUser.path
        } else {
            return NSHomeDirectory()
        }
    }
    
    func calciferDirectory() -> String {
        return home().appendingPathComponent(".calcifer")
    }
    
    func directoryExist(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return fileExists(
            atPath: path,
            isDirectory: &isDirectory) && isDirectory.boolValue
    }
    
    func directoryExist(at url: URL) -> Bool {
        return directoryExist(at: url.path)
    }
}

public extension String {
    func appendingPathComponent(_ component: String) -> String {
        return (self as NSString).appendingPathComponent(component)
    }
}
