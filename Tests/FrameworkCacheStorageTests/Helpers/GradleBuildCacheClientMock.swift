import Foundation
import XCTest
@testable import FrameworkCacheStorage

final class GradleBuildCacheClientMock: GradleBuildCacheClient {
    
    public var key: String?
    public var uploadFileURL: URL?
    public var downloadResultURL: URL?
    
    func download(
        key: String,
        completion: @escaping (BuildCacheClientResult<URL?>) -> ())
    {
        self.key = key
        completion(.success(downloadResultURL))
    }
    
    func upload(
        fileURL: URL,
        key: String,
        completion: @escaping (BuildCacheClientResult<Void>) -> ())
    {
        self.uploadFileURL = fileURL
        self.key = key
        completion(.success(()))
    }
    
}
