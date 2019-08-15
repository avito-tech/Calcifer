import Foundation

protocol Endpoint {
    func appendEndpoint(to baseURL: URL) -> URL
}
