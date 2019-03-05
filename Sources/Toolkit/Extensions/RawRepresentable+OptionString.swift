import Foundation

public extension RawRepresentable where RawValue == String {
    public var optionString: String {
        return "--\(rawValue)"
    }
}
