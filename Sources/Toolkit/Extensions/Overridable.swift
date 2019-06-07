import Foundation

extension Decodable where Self: Encodable {
    
    public func override(by another: Self) throws -> Self {
        let currentDictionary = try toDictionary()
        let anotherDictionary = try another.toDictionary()
        let overridedDictionary =  currentDictionary.merging(anotherDictionary) { (_, new) in new }
        let jsonData = try JSONSerialization.data(withJSONObject: overridedDictionary)
        return try jsonData.decode()
    }
    
    private func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data)
        guard let jsonResult = jsonObject as? [String: Any]
            else { return [:] }
        return jsonResult
    }
    
}
