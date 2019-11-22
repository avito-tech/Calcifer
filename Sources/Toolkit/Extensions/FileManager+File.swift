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
    
    func enumerate(at path: String, files: Bool, each: (String) -> ()) {
        try? contentsOfDirectory(atPath: path)
            .forEach { element in
                let elementPath = path.appendingPathComponent(element)
                if files == isFile(elementPath) {
                    each(elementPath)
                }
        }
    }
    
    func enumerateElements(at path: String, onlyFiles: Bool = true, sorted: Bool = true, onElement: (String) throws -> ()) throws {
        if isFile(path) {
            try onElement(path)
        } else {
            if !onlyFiles {
                try onElement(path)
            }
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
                    try onElement(elementPath)
                } else if !onlyFiles {
                    try onElement(elementPath)
                }
            }
        }
    }
    
    func elements(at path: String, onlyFiles: Bool = false) throws -> [String] {
        let filePathes = ThreadSafeArray<String>()
        try enumerateElements(at: path, onlyFiles: onlyFiles, sorted: false) { filePath in
          filePathes.append(filePath)
        }
        return filePathes.values.sorted()
    }
    
    func files(at path: String) throws -> [String] {
        return try elements(at: path, onlyFiles: true)
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
    
    func accessDate(at path: String) throws -> Date {
        let url = URL(fileURLWithPath: path)
        let values = try url.resourceValues(forKeys: Set([URLResourceKey.contentAccessDateKey]))
        guard let contentAccessDate = values.contentAccessDate
            else { throw FileManagerError.unableToObtainModificationDate(path: path) }
        return contentAccessDate
    }
    
}
