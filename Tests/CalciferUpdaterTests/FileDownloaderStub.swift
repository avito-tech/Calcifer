import Foundation
@testable import CalciferUpdater

public class FileDownloaderStub: FileDownloader {
    
    let onDownloadFile: (URL) -> (Result<URL, Error>)
    
    public init(onDownloadFile: @escaping (URL) -> (Result<URL, Error>)) {
        self.onDownloadFile = onDownloadFile
    }
    
    public func downloadFile(
        url: URL,
        completion: @escaping (Result<URL, Error>) -> ())
    {
        completion(onDownloadFile(url))
    }
    
}
