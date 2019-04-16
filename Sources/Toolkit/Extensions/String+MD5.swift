import Foundation

public extension String {
    public func md5() -> String {
        guard let data = data(using: .utf8) else {
            Logger.error("Can't calculate md5")
            fatalError()
        }
        return data.md5()
    }
}
