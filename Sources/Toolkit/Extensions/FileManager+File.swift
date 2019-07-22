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
    
    func enumerateFiles(at path: String, sorted: Bool = true, onFile: (String) -> ()) throws {
        if isFile(path) {
            onFile(path)
        } else {
            guard let allElements = enumerator(atPath: path)?.allObjects as? [String] else {
                return
            }
            let elements = sorted ? allElements.sorted() : allElements
            try elements.enumerateObjects(options: .concurrent) { element, _ in
                if element.contains(".DS_Store") {
                    return
                }
                let elementPath = path.appendingPathComponent(element)
                if isFile(elementPath) {
                    onFile(elementPath)
                }
            }
        }
    }
    
    func files(at path: String) throws -> [String] {
        let filePathes = ThreadSafeArray<String>()
        try enumerateFiles(at: path, sorted: false) { filePath in
            filePathes.append(filePath)
        }
        return filePathes.values.sorted()
    }
    
    func fileSize(at path: String) throws -> UInt64 {
        let attributes = try attributesOfItem(atPath: path)
        guard let fileSize = attributes[FileAttributeKey.size] as? UInt64
            else { throw FileManagerError.unableToObtainFileSize(path: path) }
        return fileSize
    }
    
    func modificationDate(at path: String) throws -> Date {
        let attributes = try attributesOfItem(atPath: path)
        guard let date = attributes[FileAttributeKey.modificationDate] as? Date
            else { throw FileManagerError.unableToObtainModificationDate(path: path) }
        return date
    }
}
