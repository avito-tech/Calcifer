import Foundation
import XcodeProj
import Checksum

protocol XcodeProjChecksumCache {
    associatedtype ChecksumType: Checksum
    func obtain(for projectPath: String) -> XcodeProjChecksumHolder<ChecksumType>?
    func store(_ xcodeProjChecksumHolder: XcodeProjChecksumHolder<ChecksumType>, for projectPath: String)
}
