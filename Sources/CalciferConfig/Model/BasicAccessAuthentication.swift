import Foundation

public struct BasicAccessAuthentication: Codable, Equatable {
    public let login: String
    public let password: String
    
    public init(
        login: String,
        password: String)
    {
        self.login = login
        self.password = password
    }
    
    public var stringValue: String {
        return "\(login):\(password)"
    }
}
