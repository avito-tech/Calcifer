import Foundation

public extension Array {
    
    enum ArrayError: Error, CustomStringConvertible {
        case failedToCastObject
        
        public var description: String {
            switch self {
            case  .failedToCastObject:
                return "Failed to cast object"
            }
        }
    }
    
    func asyncConcurrentEnumerated(
        each: (
        _ object: Element,
        _ completion: @escaping () -> (),
        _ stop: @escaping () -> ()) throws -> ()) throws
    {
        let dispatchGroup = DispatchGroup()
        let array = NSArray(array: self)
        var eachError: Error?
        array.enumerateObjects(options: .concurrent) { obj, _, stop in
            dispatchGroup.enter()
            do {
                guard let object = obj as? Element else {
                    throw ArrayError.failedToCastObject
                }
                try each(
                    object,
                    { dispatchGroup.leave() },
                    {
                        stop.pointee = true
                        dispatchGroup.leave()
                    }
                )
            } catch {
                eachError = error
                stop.pointee = true
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
        if let error = eachError {
            throw error
        }
    }
    
    func enumerateObjects(
        options: NSEnumerationOptions = [],
        each: (Element, inout Bool) throws -> Void)
        throws
    {
        var blockError: Error?
        // For performance it is very important to create a separate dictionary instance.
        // (self as NSArray).enumerateKeys... - works much slower
        let array = NSArray(array: self)
        array.enumerateObjects(options: options) { object, _, stops in
            do {
                guard let castedObject = object as? Element else {
                    throw ArrayError.failedToCastObject
                }
                var localStops = false
                try each(castedObject, &localStops)
                stops.pointee = ObjCBool(localStops)
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
