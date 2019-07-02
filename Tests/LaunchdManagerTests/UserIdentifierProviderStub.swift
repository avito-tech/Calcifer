import Foundation
import LaunchdManager

class UserIdentifierProviderStub: UserIdentifierProvider {
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    func currentUserIdentifier() throws -> String {
        return userId
    }
    
}
