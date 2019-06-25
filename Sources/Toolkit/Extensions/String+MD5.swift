import Foundation

public extension String {
    func md5() -> String {
        guard let data = data(using: .utf8) else {
            Logger.error("Can't calculate md5")
            // swiftlint:disable:next fatal_error_message
            fatalError()
        }
        return data.md5()
    }
}
