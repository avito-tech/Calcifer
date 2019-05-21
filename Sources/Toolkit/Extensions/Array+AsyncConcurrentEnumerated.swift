import Foundation

public extension Array {
    public func asyncConcurrentEnumerated(
        each: (_ object: Element, _ completion: @escaping () -> (), _ stop: () -> ()) throws -> ()) throws
    {
        let dispatchGroup = DispatchGroup()
        let array = NSArray(array: self)
        var eachError: Error?
        array.enumerateObjects(options: .concurrent) { obj, key, stop in
            guard let object = obj as? Element else {
                return
            }
            dispatchGroup.enter()
            do {
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
}
