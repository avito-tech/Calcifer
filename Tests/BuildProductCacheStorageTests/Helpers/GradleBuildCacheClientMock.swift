import Foundation
import XCTest
@testable import BuildProductCacheStorage

public final class GradleBuildCacheClientMock: GradleBuildCacheClient {
    
    public var key: String?
    public var uploadFileURL: URL?
    public var downloadResultURL: URL?
    
    public func download(
        key: String,
        completion: @escaping (BuildCacheClientResult<URL>) -> ())
    {
        self.key = key
        if let url = downloadResultURL {
            completion(.success(url))
        }
    }
    
    public func upload(
        fileURL: URL,
        key: String,
        completion: @escaping (BuildCacheClientResult<Void>) -> ())
    {
        self.uploadFileURL = fileURL
        self.key = key
        completion(.success(()))
    }
    
    public func purge(completion: @escaping (BuildCacheClientResult<Void>) -> ()) {
        completion(.success(()))
    }
    
    public func status(completion: @escaping (BuildCacheClientResult<Void>) -> ()) {
        completion(.success(()))
    }
    
    public func snapshot(completion: @escaping (BuildCacheClientResult<Void>) -> ()) {
        completion(.success(()))
    }
    
}
