import Foundation

public protocol CommandArgument {}

public extension RawRepresentable where RawValue == String, Self: CommandArgument {
    public var optionString: String {
        return "--\(rawValue)"
    }
}
