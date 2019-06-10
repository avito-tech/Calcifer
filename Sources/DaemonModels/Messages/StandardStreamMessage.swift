import Foundation

public struct StandardStreamMessage: Codable {
    public let source: StandardStreamMessageSource
    public let data: Data
    
    public init(
        source: StandardStreamMessageSource,
        data: Data)
    {
        self.source = source
        self.data = data
    }
}
