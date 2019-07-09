import Foundation

public enum ChecksumState<ChecksumType: Checksum>: Codable {
    case calculated(ChecksumType)
    case notCalculated
    
    private enum CodingKeys: String, CodingKey {
        case calculated
        case notCalculated
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let standardStreamMessage = try container.decodeIfPresent(
            ChecksumType.self,
            forKey: .calculated)
        {
            self = .calculated(standardStreamMessage)
            return
        } else {
            self = .notCalculated
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .calculated(checksum):
            try container.encode(checksum, forKey: .calculated)
        case .notCalculated:
            break
        }
    }
}
