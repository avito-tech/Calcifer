import Foundation

public extension Encodable {
    
    public func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    public func save(to path: String) throws {
        let data = try encode()
        let fileDirectoryPath = path.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            atPath: fileDirectoryPath,
            withIntermediateDirectories: true
        )
        try data.write(to: URL(fileURLWithPath: path))
    }
}
