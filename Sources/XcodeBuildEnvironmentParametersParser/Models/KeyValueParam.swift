import Foundation

public struct KeyValueParam<Value: Codable>: Codable {
    let key: String
    let value: Value
}

public extension Array where Element == KeyValueParam<String> {
    func toKeyValueDictionary() -> [String: String] {
        let keyPairs = map { ($0.key, $0.value) }
        return Dictionary<String, String>(uniqueKeysWithValues: keyPairs)
    }
}

public extension KeyValueParam where Value == Bool {
    func toStringValue() -> KeyValueParam<String> {
        return KeyValueParam<String>(
            key: key,
            value: String(value)
        )
    }
}

public extension Dictionary where Key == String, Value: Codable {
    func getKeyValueParam(_ key: Key, defaultValue: Value? = nil) throws -> KeyValueParam<Value> {
        let value = (self[key] != nil) ? self[key] : defaultValue
        guard let unwrapedValue = value else {
            throw XcodeBuildEnvironmentParametersParserError.emptyBuildParameter(
                key: key.description
            )
        }
        return KeyValueParam(
            key: key,
            value: unwrapedValue
        )
    }
}

public extension Dictionary where Key == String, Value == String {
    func getBoolKeyValueParam(_ key: Key) throws -> KeyValueParam<Bool> {
        guard let value = self[key] else {
            throw XcodeBuildEnvironmentParametersParserError.emptyBuildParameter(
                key: key.description
            )
        }
        return KeyValueParam(
            key: key,
            value: value == "YES"
        )
    }
}
