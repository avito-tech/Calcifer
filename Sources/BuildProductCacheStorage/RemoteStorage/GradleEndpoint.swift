import Foundation

enum GradleEndpoint: Endpoint {
    case cache(String)
    case purge
    case status
    case snapshot
    
    func appendEndpoint(to baseURL: URL) -> URL {
        switch self {
        case let .cache(key):
            return baseURL
                .appendingPathComponent("cache")
                .appendingPathComponent(key)
        case .purge:
            return baseURL
                .appendingPathComponent("purge")
        case .status:
            return baseURL
                .appendingPathComponent("status")
        case .snapshot:
            return baseURL
                .appendingPathComponent("snapshot")
        }
    }
}
