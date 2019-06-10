import Foundation

public struct CalciferUpdateConfig: Codable, Equatable {
    public let versionFileURL: URL
    public let zipBinaryFileURL: URL
    
    public init(
        versionFileURL: URL,
        zipBinaryFileURL: URL)
    {
        self.versionFileURL = versionFileURL
        self.zipBinaryFileURL = zipBinaryFileURL
    }
}
