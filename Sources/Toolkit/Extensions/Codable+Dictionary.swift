import Foundation

extension Decodable where Self: Encodable {
    
    public func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        guard let jsonResult = jsonObject as? [String: Any]
            else { return [:] }
        return jsonResult
    }

}

public extension Dictionary where Key == String, Value == Any {
    
    func toObject<T: Decodable>() throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: self)
        return try jsonData.decode()
    }
    
    func override(by another: [String: Any]) -> [String: Any] {
        return merging(another) { (old, new) in
            guard let newDictionary = new as? [String: Any],
                let oldDictionary = old as? [String: Any]
            else {
                return new
            }
            return oldDictionary.override(by: newDictionary)
        }
    }
    
    static func contentsOfFile(_ path: String) throws -> [String: Any] {
        guard FileManager.default.fileExists(atPath: path) else {
            return [:]
        }
        let jsonData = try NSData(contentsOfFile: path) as Data
        guard let dictionary = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any]
            else { return [:] }
        return dictionary
    }
}

