import Foundation

public extension String {
    func appendingPathComponent(_ component: String) -> String {
        return (self as NSString).appendingPathComponent(component)
    }
    
    func deletingPathExtension() -> String {
        return (self as NSString).deletingPathExtension
    }
    
    func deletingLastPathComponent() -> String {
        return (self as NSString).deletingLastPathComponent
    }
}
