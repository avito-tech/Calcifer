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
    
    func pathComponents() -> [String] {
        return (self as NSString).pathComponents
    }
    
    func pathExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    func lastPathComponent() -> String {
        return (self as NSString).lastPathComponent
    }
    
    static func path(withComponents components: [String]) -> String {
        return NSString.path(withComponents: components)
    }
}
