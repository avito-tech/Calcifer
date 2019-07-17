import Foundation
import Checksum

public protocol ChecksumHolderValidator {
    func validate<ChecksumType: Checksum>(_ holder: BaseChecksumHolder<ChecksumType>) throws
}
