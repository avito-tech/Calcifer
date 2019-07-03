import Foundation
import Checksum

class ProjectChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return targets
    }
    
    var targets = [String: TargetChecksumHolder<ChecksumType>]()
    
    init(name: String, parent: ProjChecksumHolder<ChecksumType>) {
        super.init(name: name, parent: parent)
    }
    
    override func obtainChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try cached {
            try targets.values.sorted().map {
                try $0.obtainChecksum(checksumProducer: checksumProducer)
            }.aggregate()
        }
    }
    
    func update(targets: [TargetChecksumHolder<ChecksumType>]) {
        self.targets = Dictionary(
            uniqueKeysWithValues: targets.map { ($0.name, $0) }
        )
        state = .notCalculated
    }

}
