import Foundation

public enum LDFlag {
    case library(name: String)
    case flag(name: String)
    case framework(name: String)
    case weakFramework(name: String)
    
    public var name: String {
        switch self {
        case let .library(name):
            return name
        case let .flag(name):
            return name
        case let .framework(name):
            return name
        case let .weakFramework(name):
            return name
        }
    }
    
    public var library: LDFlag? {
        if case .library = self {
            return self
        }
        return nil
    }
    
    public var flag: LDFlag? {
        if case .flag = self {
            return self
        }
        return nil
    }
    
    public var framework: LDFlag? {
        if case .framework = self {
            return self
        }
        return nil
    }
    
    public var weakFramework: LDFlag? {
        if case .weakFramework = self {
            return self
        }
        return nil
    }
}
