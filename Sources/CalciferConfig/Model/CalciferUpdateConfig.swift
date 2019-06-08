import Foundation

public struct CalciferUpdateConfig: Codable {
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
