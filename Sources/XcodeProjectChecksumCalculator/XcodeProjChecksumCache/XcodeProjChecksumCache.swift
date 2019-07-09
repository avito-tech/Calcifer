import Foundation
import XcodeProj
import Checksum

protocol XcodeProjChecksumCache {
    associatedtype ChecksumType: Checksum
    func obtain(for projectPath: String) -> XcodeProjChecksumHolder<ChecksumType>?
    func save(_ xcodeProjChecksumHolder: XcodeProjChecksumHolder<ChecksumType>, for projectPath: String)
}
