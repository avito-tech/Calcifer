import Foundation

final class StubURLSession: URLSession {
    
    public var downloadStub: ((URLRequest) -> (URL?, URLResponse?, Error?))?
    public var uploadStub: ((URLRequest, URL) -> (Data?, URLResponse?, Error?))?
    
    override func downloadTask(
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
    
    override func uploadTask(
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
