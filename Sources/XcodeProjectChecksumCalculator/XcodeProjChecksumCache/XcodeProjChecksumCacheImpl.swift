import Foundation
import XcodeProj
import Checksum
import Toolkit

final class XcodeProjChecksumCacheImpl: XcodeProjChecksumCache {
    
    let storage = BaseKeyValueStorage<String, XcodeProjChecksumHolder<BaseChecksum>>()
    
    public static let shared: XcodeProjChecksumCacheImpl = {
        return XcodeProjChecksumCacheImpl()
    }()
    
    init() {}
    
    func obtain(for projectPath: String) -> XcodeProjChecksumHolder<BaseChecksum>? {
        return storage.obtain(for: projectPath)
    }
    
    func store(_ xcodeProjChecksumHolder: XcodeProjChecksumHolder<BaseChecksum>, for projectPath: String) {
        storage.addValue(xcodeProjChecksumHolder, for: projectPath)
    }
    
}
