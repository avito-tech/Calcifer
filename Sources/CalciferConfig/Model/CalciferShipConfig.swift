import Foundation

public struct CalciferShipConfig: Codable, Equatable {
    public let versionFileURL: URL
    public let zipBinaryFileURL: URL
    public let basicAccessAuthentication: BasicAccessAuthentication?
    
    public init(
        versionFileURL: URL,
        zipBinaryFileURL: URL,
        basicAccessAuthentication: BasicAccessAuthentication?)
    {
        self.versionFileURL = versionFileURL
        self.zipBinaryFileURL = zipBinaryFileURL
        self.basicAccessAuthentication = basicAccessAuthentication
    }
    
}
