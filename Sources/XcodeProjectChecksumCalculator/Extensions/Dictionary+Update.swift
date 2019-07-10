import Foundation
import Toolkit

public extension Dictionary {
    func update<Updatable>(
        childrenDictionary: inout [Key: Updatable],
        update: (Updatable, Value) throws -> (),
        buildValue: (Value) -> (Updatable))
        throws -> Bool
    {
        var changed = false
        try enumerateKeysAndObjects(options: .concurrent) { key, value, _ in
            if let existedValue = childrenDictionary[key] {
                try update(existedValue, value)
                return
            }
            // For bool this is thread safe. Since it changes only in true.
            changed = true
            let newValue = buildValue(value)
            try update(newValue, value)
            childrenDictionary[key] = newValue
        }
        try childrenDictionary.enumerateKeysAndObjects(options: .concurrent) { key, value, _ in
            if let _ = self[key] {
                return
            }
            childrenDictionary.removeValue(forKey: key)
            // For bool this is thread safe. Since it changes only in true.
            changed = true
        }
        return changed
    }
}
