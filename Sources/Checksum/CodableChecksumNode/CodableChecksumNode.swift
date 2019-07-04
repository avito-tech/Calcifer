import Foundation

public final class CodableChecksumNode<Value: Codable & Hashable>: Codable, Equatable, CustomStringConvertible {
    
    public let name: String
    public let value: Value
    public let children: [CodableChecksumNode<Value>]
    
    public init(name: String, value: Value, children: [CodableChecksumNode<Value>]) {
        self.name = name
        self.value = value
        self.children = children
    }
    
    public static func == (lhs: CodableChecksumNode<Value>, rhs: CodableChecksumNode<Value>) -> Bool {
        return lhs.name == rhs.name && lhs.value == rhs.value
    }
    
    public var description: String {
        return "\(name) \(value)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case value
        case children
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(value, forKey: .value)
        if !children.isEmpty {
            try container.encode(children, forKey: .children)
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        value = try container.decode(Value.self, forKey: .value)
        children = try container.decodeIfPresent([CodableChecksumNode<Value>].self, forKey: .children) ?? []
    }
}
