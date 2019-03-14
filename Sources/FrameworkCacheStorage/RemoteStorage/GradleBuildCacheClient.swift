import Foundation

public final class GradleBuildCacheClient {
    
    private let gradleHost: URL
    private let session = URLSession.shared
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    public init(gradleHost: URL) {
        self.gradleHost = gradleHost
    }
    
    func upload(
        fileURL: URL,
        key: String,
        completion: @escaping (Result<Void>) -> ())
    {
        let uploadURL = url(key: key)
        uploadFile(
            uploadURL: uploadURL,
            fileURL: fileURL,
            completion: completion
        )
    }
    
    func download(key: String, completion: @escaping (Result<URL?>) -> ()) {
        let downloadURL = url(key: key)
        downloadFile(
            downloadURL: downloadURL,
            completion: completion
        )
    }
    
    private func uploadFile(
        uploadURL: URL,
        fileURL: URL,
        completion: @escaping (Result<Void>) -> ())
    {
        var request = URLRequest(
            url: uploadURL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 60
        )
        request.httpMethod = "PUT"
        let task = session.uploadTask(
            with: request,
            fromFile: fileURL)
        { data, response, error in
            guard let error = error else {
                completion(Result<Void>.success(()))
                return
            }
            completion(Result.failure(error))
        }
        task.resume()
    }
    
    private func downloadFile(
        downloadURL: URL,
        completion: @escaping (Result<URL?>) -> ())
    {
        let request = URLRequest(
            url: downloadURL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 60
        )
        let task = session.downloadTask(
            with: request)
        { localURL, response, error in
            guard let error = error else {
                completion(Result.success(localURL))
                return
            }
            completion(Result.failure(error))
        }
        task.resume()
    }
    
    private func url(key: String) -> URL {
        let url = gradleHost
            .appendingPathComponent("cache")
            .appendingPathComponent(key)
        return url
    }
}
