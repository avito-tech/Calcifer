import Foundation

public extension Array {
    func toDictionary<Key: Hashable>(_ provideKey: (Element) -> (Key)) -> [Key: Element] {
        return Dictionary(uniqueKeysWithValues: map { (provideKey($0), $0) })
    }
}
