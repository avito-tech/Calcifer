import Foundation

public protocol UpdateChecker {
    func shouldUpdateCalcifer(
        versionFileURL: URL,
        completion: @escaping (Result<Bool, Error>) -> ()
    )
}
