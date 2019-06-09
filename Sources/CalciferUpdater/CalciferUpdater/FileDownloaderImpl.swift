import Foundation

public final class FileDownloaderImpl: FileDownloader {
    
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
    
    public func downloadFile(url: URL, completion: @escaping (Result<URL, Error>) -> ()) {
        session.downloadTask(with: url) { (downloadedURL, _, error) in
            guard let downloadedURL = downloadedURL, error == nil else {
                let downloadError = error ?? CalciferUpdaterError.failedToDownloadFile(url: url)
                completion(.failure(downloadError))
                return
            }
            completion(.success(downloadedURL))
        }.resume()
    }
    
}
