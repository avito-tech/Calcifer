import Foundation
import PathKit

public protocol URLChecksumProducer: ChecksumProducer where Input == URL {}

public final class BaseURLChecksumProducer: URLChecksumProducer {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    public func checksum(input: URL) throws -> BaseChecksum {
        let path = input.path
        
        let isFile = try checkIsFile(filePath: path)
        if isFile {
            return try checksum(for: input)
        }
        return try folderChecksum(path)
    }
    
    private func checksum(for file: URL) throws -> BaseChecksum {
        do {
            let string = try Data(contentsOf: file).md5()
            return BaseChecksum(string)
        } catch {
            throw error
        }
    }
    
    private func checkIsFile(filePath: String) throws -> Bool {
        var isDirectory: ObjCBool = false
        let fileExist = fileManager.fileExists(atPath: filePath, isDirectory: &isDirectory)
        if fileExist == false {
            throw ChecksumError.fileDoesntExist(path: filePath)
        }
        return !isDirectory.boolValue
    }
    
    private func folderChecksum(_ path: String) throws -> BaseChecksum {
        let enumerator = fileManager.enumerator(atPath: path)
        var filesChecksums = [BaseChecksum]()
        while let element = enumerator?.nextObject() as? String {
            let url = URL(fileURLWithPath: element)
            let isFile = try checkIsFile(filePath: path)
            if isFile {
                let checksumValue = try checksum(for: url)
                filesChecksums.append(checksumValue)
            }
        }
        return try filesChecksums.aggregate()
    }
    
}
