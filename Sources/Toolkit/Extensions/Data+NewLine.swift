import Foundation

public extension Data {
    func addTrailingNewLine() -> Data {
        guard let string = String(data: self, encoding: .utf8),
            !string.hasSuffix("\n")
            else { return self }
        guard let patched = (string + "\n").data(using: .utf8)
            else { return self }
        return patched
    }
}
