import Foundation

public struct CalciferShipConfig: Codable {
    public let versionFileURL: URL
    public let zipBinaryFileURL: URL
    public let basicAccessAuthentication: String?
    
    public init(
        versionFileURL: URL,
        zipBinaryFileURL: URL,
        basicAccessAuthentication: String?)
    {
        self.versionFileURL = versionFileURL
        self.zipBinaryFileURL = zipBinaryFileURL
        self.basicAccessAuthentication = basicAccessAuthentication
    }
}
