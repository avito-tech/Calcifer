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
        let fileManager = FileManager.default
        if fileManager.directoryExist(at: fileDirectoryPath) == false {
            try fileManager.createDirectory(
                atPath: fileDirectoryPath,
                withIntermediateDirectories: true
            )
        }
        try data.write(to: URL(fileURLWithPath: path))
    }
}

public extension Decodable {
    static func decode(from path: String) throws -> Self {
        let url = URL(fileURLWithPath: path)
        let jsonData = try Data(contentsOf: url)
        return try jsonData.decode()
    }
}

public extension Data {
    func decode<T: Decodable>(type: T.Type = T.self) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: self)
    }
}
