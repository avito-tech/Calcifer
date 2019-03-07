import Foundation

// You can find all types in `gcc --help`
public enum LinkerFlag {
    case library(name: String)
    case framework(name: String)
    case weakFramework(name: String)
    case flag(name: String)
    case flagWithValue(name: String, value: String)
    
    public var name: String {
        switch self {
        case let .library(name):
            return name
        case let .framework(name):
            return name
        case let .weakFramework(name):
            return name
        case let .flag(name):
            return name
        case let .flagWithValue(name, _):
            return name
        }
    }
    
    public var library: LinkerFlag? {
        if case .library = self {
            return self
        }
        return nil
    }
    
    public var framework: LinkerFlag? {
        if case .framework = self {
            return self
        }
        return nil
    }
    
    public var weakFramework: LinkerFlag? {
        if case .weakFramework = self {
            return self
        }
        return nil
    }
    
    public var flag: LinkerFlag? {
        if case .flag = self {
            return self
        }
        return nil
    }
}
