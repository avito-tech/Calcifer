import Foundation

public protocol UserIdentifierProvider {
    func currentUserIdentifier() throws -> String
}
