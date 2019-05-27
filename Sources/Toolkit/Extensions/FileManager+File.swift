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
        // .noindex - remove from spotlight index
        return home().appendingPathComponent(".calcifer.noindex")
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
    
    func isFile(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        fileExists(atPath: path, isDirectory: &isDirectory)
        return !isDirectory.boolValue
    }
    
    func enumerateFiles(at path: String, onFile: (String) -> ()) {
        if isFile(path) {
            onFile(path)
        } else {
            guard let allElements = enumerator(atPath: path)?.allObjects as? [String] else {
                return
            }
            let sortedElements = allElements.sorted()
            for element in sortedElements {
                if element.contains(".DS_Store") {
                    continue
                }
                let elementPath = path.appendingPathComponent(element)
                if isFile(elementPath) {
                    onFile(elementPath)
                }
            }
        }
    }
    
    func files(at path: String) -> [String] {
        var filePathArray = [String: String]()
        enumerateFiles(at: path) { filePath in
            filePathArray[filePath] = filePath
        }
        return Array(filePathArray.values.sorted())
    }
    
    func fileSize(at path: String) -> UInt64? {
        let attributes = catchError { try FileManager.default.attributesOfItem(atPath: path) }
        guard let fileSize = attributes[FileAttributeKey.size] as? UInt64
            else { return nil }
        return fileSize
    }
    
    func modificationDate(at path: String) -> Date? {
        let attributes = catchError { try FileManager.default.attributesOfItem(atPath: path) }
        guard let date = attributes[FileAttributeKey.modificationDate] as? Date
            else { return nil }
        return date
    }
}
