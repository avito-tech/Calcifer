import Foundation

public extension String {
    public func md5() throws -> String? {
        guard let data = data(using: .utf8) else {
           return nil
        }
        return data.md5()
    }
}
