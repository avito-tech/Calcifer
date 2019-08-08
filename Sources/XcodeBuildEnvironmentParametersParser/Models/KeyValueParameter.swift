import Foundation

public struct KeyValueParameter<Value: Codable>: Codable {
    let key: String
    let value: Value
}

public extension Array where Element == KeyValueParameter<String> {
    func toKeyValueDictionary() -> [String: String] {
        let keyPairs = map { ($0.key, $0.value) }
        return Dictionary<String, String>(uniqueKeysWithValues: keyPairs)
    }
}

public extension KeyValueParameter where Value == Bool {
    func toStringValue() -> KeyValueParameter<String> {
        return KeyValueParameter<String>(
            key: key,
            value: String(value)
        )
    }
}

public extension Dictionary where Key == String, Value: Codable {
    func getKeyValueParam(_ key: Key, defaultValue: Value? = nil) throws -> KeyValueParameter<Value> {
        let value = (self[key] != nil) ? self[key] : defaultValue
        guard let unwrapedValue = value else {
            throw XcodeBuildEnvironmentParametersParserError.emptyBuildParameter(
                key: key.description
            )
        }
        return KeyValueParameter(
            key: key,
            value: unwrapedValue
        )
    }
}

public extension Dictionary where Key == String, Value == String {
    func getBoolKeyValueParam(_ key: Key) throws -> KeyValueParameter<Bool> {
        guard let value = self[key] else {
            throw XcodeBuildEnvironmentParametersParserError.emptyBuildParameter(
                key: key.description
            )
        }
        return KeyValueParameter(
            key: key,
            value: value == "YES"
        )
    }
}
