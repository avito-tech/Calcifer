import Foundation

public extension Dictionary {
    func enumerateKeysAndObjects(
        options opts: NSEnumerationOptions = [],
        using block: (Key, Value, UnsafeMutablePointer<ObjCBool>) throws -> Void
    ) throws {
        var blockError: Error?
        // For performance it is very important to create a separate dictionary instance.
        // (self as NSDictionary).enumerateKeys... - works much slower
        let dictionary = NSDictionary(dictionary: self)
        dictionary.enumerateKeysAndObjects(options: opts) { key, object, stops in
            do {
                if let castedObject = object as? Value, let castedKey = key as? Key {
                    try block(castedKey, castedObject, stops)
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
