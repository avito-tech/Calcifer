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
    
    func appendingPathExtension(_ pathExtension: String) -> String {
        guard let result = (self as NSString).appendingPathExtension(pathExtension) else {
            return "\(self).\(pathExtension)"
        }
        return result
    }
    
    static func path(withComponents components: [String]) -> String {
        return NSString.path(withComponents: components)
    }
    
    func relativePath(to rootPath: String) -> String? {
        let rootComponents = rootPath.pathComponents()
        let components = pathComponents()
        var equalIndex = 0
        for (index, rootComponent) in rootComponents.enumerated() {
            if components[index] == rootComponent {
                equalIndex = index
            } else {
                return nil
            }
        }
        return String.path(withComponents: Array(components.dropFirst(equalIndex)))
    }
}
