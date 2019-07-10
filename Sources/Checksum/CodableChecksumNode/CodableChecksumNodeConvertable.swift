import Foundation

public protocol CodableChecksumNodeConvertable {
    associatedtype Value: Codable & Hashable
    func node() -> CodableChecksumNode<Value>
}
