import Foundation

public final class LDFlagParser {
    
    public init() {}
    
    public func parse(ldFlagsString: String) -> [LDFlag] {
        var ldFlags = [LDFlag]()
        let components = ldFlagsString.components(separatedBy: " ")
        for (index, string) in components.enumerated() {
            
            if string.hasPrefix("-l\"") && string.hasSuffix("\"") {
                if let name = escapingValue(from: string.chopPrefix(2)) {
                    ldFlags.append(.library(name: name))
                }
                continue
            }
            
            if string == "-framework" && index + 1 < components.count {
                let nextString = components[index + 1]
                if let frameworkName = escapingValue(from: nextString) {
                    ldFlags.append(.framework(name: frameworkName))
                }
                continue
            }
            
            if string == "-weak_framework" && index + 1 < components.count {
                let nextString = components[index + 1]
                if let frameworkName = escapingValue(from: nextString) {
                    ldFlags.append(.weakFramework(name: frameworkName))
                }
                continue
            }
            
            if string.hasPrefix("-") {
                ldFlags.append(.flag(name: String(string.dropFirst())))
            }
        }
        return ldFlags
    }
    
    private func escapingValue(from string: String) -> String? {
        let escapingString = "\""
        if string.hasPrefix(escapingString) && string.hasSuffix(escapingString) {
            return string.components(separatedBy: escapingString)[1]
        }
        return nil
    }
    
}
