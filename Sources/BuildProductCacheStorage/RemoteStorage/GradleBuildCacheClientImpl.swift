import Foundation

public final class GradleBuildCacheClientImpl: GradleBuildCacheClient {
    
    private let gradleHost: URL
    private let session: URLSession
    
    public init(gradleHost: URL, session: URLSession) {
        self.gradleHost = gradleHost
        self.session = session
    }
    
    public func upload(
        fileURL: URL,
        key: String,
        completion: @escaping (BuildCacheClientResult<Void>) -> ())
    {
        let uploadURL = url(key: key)
        uploadFile(
            uploadURL: uploadURL,
            fileURL: fileURL,
            completion: completion
        )
    }
    
    public func download(
        key: String,
        completion: @escaping (BuildCacheClientResult<URL>) -> ())
    {
        let downloadURL = url(key: key)
        downloadFile(
            downloadURL: downloadURL,
            completion: completion
        )
    }
    
    private func uploadFile(
        uploadURL: URL,
        fileURL: URL,
        completion: @escaping (BuildCacheClientResult<Void>) -> ())
    {
        var request = URLRequest(
            url: uploadURL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 60
        )
        request.httpMethod = "PUT"
        session.uploadTask(with: request, fromFile: fileURL) { _, _, error in
            guard let error = error else {
                completion(BuildCacheClientResult<Void>.success(()))
                return
            }
            completion(BuildCacheClientResult.failure(error))
        }.resume()
    }
    
    private func downloadFile(
        downloadURL: URL,
        completion: @escaping (BuildCacheClientResult<URL>) -> ())
    {
        let request = URLRequest(
            url: downloadURL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 60
        )
        session.downloadTask(with: request) { localURL, response, error in
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let fileURL = localURL
                else
            {
                completion(BuildCacheClientResult.failure(error))
                return
            }
            completion(BuildCacheClientResult.success(fileURL))
        }.resume()
    }
    
    @inline(__always) private func url(key: String) -> URL {
        let url = gradleHost
            .appendingPathComponent("cache")
            .appendingPathComponent(key)
        return url
    }
}
