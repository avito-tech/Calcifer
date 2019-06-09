import Foundation

public protocol FileDownloader {
    func downloadFile(
        url: URL,
        completion: @escaping (Result<URL, Error>) -> ()
    )
}
