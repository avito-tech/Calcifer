import Foundation

public struct StandardStreamMessage: Codable {
    let source: StandardStreamMessageSource
    let data: Data
    
    init(
        source: StandardStreamMessageSource,
        data: Data)
    {
        self.source = source
        self.data = data
    }
}
