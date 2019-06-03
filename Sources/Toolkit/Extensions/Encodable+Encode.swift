import Foundation

public extension Encodable {
    
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    func save(to path: String) throws {
        let data = try encode()
        let fileDirectoryPath = path.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            atPath: fileDirectoryPath,
            withIntermediateDirectories: true
        )
        try data.write(to: URL(fileURLWithPath: path))
    }
}

public extension Data {
    func decode<T: Decodable>(type: T.Type = T.self) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: self)
    }
}
