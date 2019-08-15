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
        let request = createRequest(for: .cache(key), httpMethod: .put)
        session.uploadTask(with: request, fromFile: fileURL) { _, _, error in
            guard let error = error else {
                completion(BuildCacheClientResult<Void>.success(()))
                return
            }
            completion(BuildCacheClientResult.failure(error))
        }.resume()
    }
    
    public func download(
        key: String,
        completion: @escaping (BuildCacheClientResult<URL>) -> ())
    {
        let request = createRequest(for: .cache(key))
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
    
    public func status(completion: @escaping (BuildCacheClientResult<Void>) -> ()) {
        let request = createRequest(for: .status)
        session.dataTask(with: request) { _, _, error in
            guard let error = error else {
                completion(BuildCacheClientResult<Void>.success(()))
                return
            }
            completion(BuildCacheClientResult.failure(error))
        }.resume()
    }
    
    public func snapshot(completion: @escaping (BuildCacheClientResult<Void>) -> ()) {
        let request = createRequest(for: .snapshot)
        session.dataTask(with: request) { _, _, error in
            guard let error = error else {
                completion(BuildCacheClientResult<Void>.success(()))
                return
            }
            completion(BuildCacheClientResult.failure(error))
        }.resume()
    }
    
    public func purge(completion: @escaping (BuildCacheClientResult<Void>) -> ()) {
        let request = createRequest(for: .purge, httpMethod: .post)
        session.dataTask(with: request) { _, _, error in
            guard let error = error else {
                completion(BuildCacheClientResult<Void>.success(()))
                return
            }
            completion(BuildCacheClientResult.failure(error))
        }.resume()
    }
    
    private func createRequest(for gradleEndpoint: GradleEndpoint, httpMethod: HttpMethod = .get) -> URLRequest {
        var request = URLRequest(
            url: url(for: gradleEndpoint),
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 60
        )
        request.httpMethod = httpMethod.rawValue
        return request
    }
    
    @inline(__always) private func url(for gradleEndpoint: GradleEndpoint) -> URL {
        return gradleEndpoint.appendEndpoint(to: gradleHost)
    }
}
