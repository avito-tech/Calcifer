import Foundation
import XcodeProj
import Checksum
import Toolkit

public final class XcodeProjChecksumCacheImpl: BaseXcodeProjChecksumCache {
    
    let storage = BaseKeyValueStorage<String, XcodeProjChecksumHolder<BaseChecksum>>()
    
    override public init() {}
    
    override public func obtain(for projectPath: String) -> XcodeProjChecksumHolder<BaseChecksum>? {
        return storage.obtain(for: projectPath)
    }
    
    override public func store(
        _ xcodeProjChecksumHolder: XcodeProjChecksumHolder<BaseChecksum>,
        for projectPath: String)
    {
        storage.addValue(xcodeProjChecksumHolder, for: projectPath)
    }
    
}
