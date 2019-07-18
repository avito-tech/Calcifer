import Foundation
import Toolkit

public extension Dictionary {
    func update<Updatable>(
        childrenDictionary: ThreadSafeDictionary<Key, Updatable>,
        update: (Updatable, Value) throws -> (),
        onRemove: (Key) -> (),
        buildValue: (Value) -> (Updatable))
        throws -> Bool
    {
        var changed = false
        try enumerateKeysAndObjects(options: .concurrent) { key, value, _ in
            if let existedValue = childrenDictionary.read(key) {
                try update(existedValue, value)
                return
            }
            // For bool this is thread safe. Since it changes only in true.
            changed = true
            let newValue = buildValue(value)
            try update(newValue, value)
            childrenDictionary.write(newValue, for: key)
        }
        try childrenDictionary
            .copy()
            .enumerateKeysAndObjects(options: .concurrent) { key, _, _ in
                if self[key] != nil {
                    return
                }
                onRemove(key)
                childrenDictionary.removeValue(forKey: key)
                // For bool this is thread safe. Since it changes only in true.
                changed = true
            }
        return changed
    }
}
