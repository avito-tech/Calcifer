import Foundation

public extension FileManager {
    func write(_ content: [String: Any], to filePath: String) throws {
        let dictionary = NSDictionary(dictionary: content)
        if fileExists(atPath: filePath) {
            let fileContent = NSDictionary(contentsOfFile: filePath)
            if fileContent == dictionary {
                return
            }
        }
        let directoryPath = filePath.deletingLastPathComponent()
        if directoryExist(at: directoryPath) == false {
            try createDirectory(
                atPath: directoryPath,
                withIntermediateDirectories: true
            )
        }
        let isWritten = dictionary.write(toFile: filePath, atomically: true)
        if isWritten == false {
            throw FileManagerError.unableToWriteFile(
                path: filePath,
                content: content
            )
        }
    }
}
