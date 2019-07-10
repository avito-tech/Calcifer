import Foundation

public extension Array {
    func toDictionary<Key: Hashable>(_ keyProvider: (Element) -> (Key)) -> [Key: Element] {
        return Dictionary(uniqueKeysWithValues: map { (keyProvider($0), $0) })
    }
}
