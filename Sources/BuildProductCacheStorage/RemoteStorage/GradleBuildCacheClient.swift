import Foundation

public protocol GradleBuildCacheClient {
    func download(
        key: String,
        completion: @escaping (BuildCacheClientResult<URL>) -> ()
    )
    
    func upload(
        fileURL: URL,
        key: String,
        completion: @escaping (BuildCacheClientResult<Void>) -> ()
    )
    
    func purge(
        completion: @escaping (BuildCacheClientResult<Void>) -> ()
    )
    
    func status(
        completion: @escaping (BuildCacheClientResult<Void>) -> ()
    )
    
    func snapshot(
        completion: @escaping (BuildCacheClientResult<Void>) -> ()
    )
}
