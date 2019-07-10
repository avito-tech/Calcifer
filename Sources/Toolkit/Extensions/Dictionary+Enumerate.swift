import Foundation

public extension Dictionary {
    
    enum DictionaryError: Error, CustomStringConvertible {
        case failedToCastObject
        
        public var description: String {
            switch self {
            case  .failedToCastObject:
                return "Failed to cast object"
            }
        }
    }
    
    func enumerateKeysAndObjects(
        options: NSEnumerationOptions = [],
        iterator: (Key, Value, inout Bool) throws -> Void
    ) throws {
        var blockError: Error?
        // For performance it is very important to create a separate dictionary instance.
        // (self as NSDictionary).enumerateKeys... - works much slower
        let dictionary = NSDictionary(dictionary: self)
        dictionary.enumerateKeysAndObjects(options: options) { key, object, stops in
            do {
                var localStops = false
                if let castedObject = object as? Value, let castedKey = key as? Key {
                    try iterator(castedKey, castedObject, &localStops)
                    stops.pointee = ObjCBool(localStops)
                } else {
                    throw DictionaryError.failedToCastObject
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
