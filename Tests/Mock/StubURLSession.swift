import Foundation

public final class StubURLSession: URLSession {
    
    override public init() {}
    
    // swiftlint:disable:next large_tuple
    public var downloadStub: ((URLRequest) -> (URL?, URLResponse?, Error?))?
    // swiftlint:disable:next large_tuple
    public var uploadStub: ((URLRequest, URL) -> (Data?, URLResponse?, Error?))?
    
    override public func downloadTask(
        with request: URLRequest,
        completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void)
        -> URLSessionDownloadTask
    {
        let task = StubURLSessionDownloadTask { [weak self] in
            guard let downloadStub = self?.downloadStub
                else { return }
            let (url, response, error) = downloadStub(request)
            completionHandler(url, response, error)
        }
        return task
    }
    
    override public func uploadTask(
        with request: URLRequest,
        fromFile fileURL: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionUploadTask
    {
        let tast = StubURLSessionUploadTask { [weak self] in
            guard let uploadStub = self?.uploadStub
                else { return }
            let (data, response, error) = uploadStub(request, fileURL)
            completionHandler(data, response, error)
        }
        return tast
    }
}
