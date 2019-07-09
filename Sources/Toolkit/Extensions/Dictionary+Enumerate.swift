import Foundation

public extension Dictionary {
    func enumerateKeysAndObjects(
        options opts: NSEnumerationOptions = [],
        using closure: (Key, Value, inout Bool) throws -> Void
    ) throws {
        var blockError: Error?
        // For performance it is very important to create a separate dictionary instance.
        // (self as NSDictionary).enumerateKeys... - works much slower
        let dictionary = NSDictionary(dictionary: self)
        dictionary.enumerateKeysAndObjects(options: opts) { key, object, stops in
            do {
                var localStops = false
                if let castedObject = object as? Value, let castedKey = key as? Key {
                    try closure(castedKey, castedObject, &localStops)
                    stops.pointee = ObjCBool(localStops)
                }
            } catch {
                blockError = error
                stops.pointee = true
            }
        }
        if let error = blockError {
            throw error
        }
    }
}
