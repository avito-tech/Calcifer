import Foundation
@testable import CalciferUpdater

public class UpdateCheckerStub: UpdateChecker {
    
    let onShouldUpdate: (URL) -> (Result<Bool, Error>)
    
    public init(onShouldUpdate: @escaping (URL) -> (Result<Bool, Error>)) {
        self.onShouldUpdate = onShouldUpdate
    }
    
    public func shouldUpdateCalcifer(
        versionFileURL: URL,
        completion: @escaping (Result<Bool, Error>) -> ())
    {
        completion(onShouldUpdate(versionFileURL))
    }
    
}
