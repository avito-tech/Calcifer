import Foundation

public protocol GradleBuildCacheClient {
    func download(
        key: String,
        completion: @escaping (BuildCacheClientResult<URL?>) -> ()
    )
    
    func upload(
        fileURL: URL,
        key: String,
        completion: @escaping (BuildCacheClientResult<Void>) -> ()
    )
}
