import Foundation
import Checksum

class FileChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {

    let fileURL: URL
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return [:]
    }
    
    init(fileURL: URL, parent: BaseChecksumHolder<ChecksumType>) {
        self.fileURL = fileURL
        super.init(name: fileURL.path, parent: parent)
    }
    
    override func obtainChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try cached {
            try checksumProducer.checksum(input: fileURL)
        }
    }

}
