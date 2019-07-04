import Foundation
import Checksum

class XcodeProjChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String : BaseChecksumHolder<ChecksumType>] {
        return projs
    }
    
    var projs = [String: ProjChecksumHolder<ChecksumType>]()
    
    init(name: String) {
        super.init(
            name: name,
            parent: nil
        )
    }
    
    override func obtainChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try cached {
            try projs.values.sorted().map {
                try $0.obtainChecksum(checksumProducer: checksumProducer)
            }.aggregate()
        }
    }
    
    func update(projChecksum: ProjChecksumHolder<ChecksumType>) {
        self.projs = [projChecksum.name: projChecksum]
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
