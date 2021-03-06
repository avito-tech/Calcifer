import Foundation

public final class LinkerFlagParser {
    
    public init() {}
    
    public func parse(linkerFlags: String) -> [LinkerFlag] {
        var flags = [LinkerFlag]()
        let components = linkerFlags.components(separatedBy: " ")
        for (index, string) in components.enumerated() {
            
            if string == "-framework" && index + 1 < components.count {
                let nextString = components[index + 1]
                let frameworkName = escapingValue(from: nextString)
                flags.append(.framework(name: frameworkName))
                continue
            }
            
            if string == "-weak_framework" && index + 1 < components.count {
                let nextString = components[index + 1]
                let frameworkName = escapingValue(from: nextString)
                flags.append(.weakFramework(name: frameworkName))
                continue
            }
            
            // Also can be `-l/path/to/libSystem.dylib` or `-l /path/to/libSystem.dylib`
            if string.hasPrefix("-l\"") && string.hasSuffix("\"") {
                let name = escapingValue(from: string.chomp(2))
                flags.append(.library(name: name))
                continue
            }
            
            if string.hasPrefix("-") {
                if index + 1 < components.count {
                    let nextString = components[index + 1]
                    let name = String(string.dropFirst())
                    if nextString.hasPrefix("-") {
                        flags.append(.flag(name: name))
                        continue
                    } else {
                        let value = escapingValue(from: nextString)
                        flags.append(.flagWithValue(name: name, value: value))
                    }
                }
                
            }
        }
        return flags
    }
    
    private func escapingValue(from string: String) -> String {
        let escapingString = "\""
        if string.hasPrefix(escapingString) && string.hasSuffix(escapingString) {
            return string.components(separatedBy: escapingString)[1]
        }
        return string
    }
    
}
