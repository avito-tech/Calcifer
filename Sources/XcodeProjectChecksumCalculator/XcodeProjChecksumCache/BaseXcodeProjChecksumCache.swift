import Foundation
import XcodeProj
import Checksum

open class BaseXcodeProjChecksumCache: XcodeProjChecksumCache {
    open func obtain(for projectPath: String) -> XcodeProjChecksumHolder<BaseChecksum>? {
        fatalError("Must be overriden")
    }
    
    open func store(_ xcodeProjChecksumHolder: XcodeProjChecksumHolder<BaseChecksum>, for projectPath: String) {
        fatalError("Must be overriden")
    }
}
