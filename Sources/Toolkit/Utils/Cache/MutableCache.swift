import Foundation

public protocol MutableCache: Cache {
    func addValue(_ value: Value, for key: Key)
}
