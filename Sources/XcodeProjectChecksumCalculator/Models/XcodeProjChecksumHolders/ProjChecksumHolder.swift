import Foundation
import Checksum

class ProjChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    var projects = [String: ProjectChecksumHolder<ChecksumType>]()
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return projects
    }
    
    init(name: String, parent: XcodeProjChecksumHolder<ChecksumType>) {
        super.init(name: name, parent: parent)
    }
    
    override func obtainChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try cached {
            try projects.values.sorted().map {
                try $0.obtainChecksum(checksumProducer: checksumProducer)
            }.aggregate()
        }
    }
    
    func update(projects: [ProjectChecksumHolder<ChecksumType>]) {
        self.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.name, $0) })
        state = .notCalculated
    }
}
