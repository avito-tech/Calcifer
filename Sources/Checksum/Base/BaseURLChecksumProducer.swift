import Foundation
import PathKit

public protocol URLChecksumProducer: ChecksumProducer where Input == URL {}

public final class BaseURLChecksumProducer: URLChecksumProducer {
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    public func checksum(input: URL) throws -> BaseChecksum {
        let path = input.path
        let resultChecksum: BaseChecksum
        let isFile = try checkIsFile(filePath: path)
        if isFile {
            resultChecksum = try checksum(for: input)
        } else {
            resultChecksum = try folderChecksum(path)
        }
        if resultChecksum == .zero {
            throw ChecksumError.zeroChecksum(path: input.path)
        }
        return resultChecksum
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
        guard let allElements = enumerator?.allObjects as? [String] else {
            throw ChecksumError.unableToEnumerateDirectory(path: path)
        }
        let sortedElements = allElements.sorted()
        for element in sortedElements {
            let elementPath = (path as NSString).appendingPathComponent(element)
            let isFile = try checkIsFile(filePath: elementPath)
            if isFile {
                let fileURL = URL(fileURLWithPath: elementPath)
                let checksumValue = try checksum(for: fileURL)
                filesChecksums.append(checksumValue)
            }
        }
        return try filesChecksums.aggregate()
    }
    
}
