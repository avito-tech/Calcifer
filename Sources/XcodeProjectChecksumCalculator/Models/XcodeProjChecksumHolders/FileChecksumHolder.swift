import Foundation
import Checksum

import XcodeProj
import PathKit

class FileChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {

    let fileURL: URL
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return [:]
    }
    
    init(
        fileURL: URL,
        parent: BaseChecksumHolder<ChecksumType>)
    {
        self.fileURL = fileURL
        super.init(name: fileURL.path, parent: parent)
    }
    
    override public func calculateChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try checksumProducer.checksum(input: fileURL)
    }
    
    open func reflectUpdate(updateModel: URL) throws {}
}
