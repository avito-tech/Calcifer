import Foundation
import Toolkit

public final class ConcurentLeafsChecksumCalculator: ChecksumCalculator {
    
    public init() {}
    
    public func calculate<ChecksumType: Checksum>(
        rootHolder: BaseChecksumHolder<ChecksumType>)
        throws -> ChecksumType
    {
        var notCalculatedLeafs = rootHolder.obtainNotCalculatedLeafs()
        let calculated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        while !notCalculatedLeafs.isEmpty {
            try notCalculatedLeafs.enumerateKeysAndObjects(options: .concurrent) { _, node, _ in
                _ = try node.obtainChecksum()
                calculated.write(node, for: node.name)
            }
            let newNotCalculatedLeafs = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
            try notCalculatedLeafs.enumerateKeysAndObjects(options: .concurrent) { _, leaf, _ in
                for parent in leaf.parents.values {
                    if parent.calculated {
                        calculated.write(parent, for: parent.name)
                        continue
                    }
                    if calculated.read(parent.name) != nil {
                        continue
                    }
                    newNotCalculatedLeafs.write(parent, for: parent.name)
                }
            }
            notCalculatedLeafs = newNotCalculatedLeafs
        }
        let checksum = try rootHolder.obtainChecksum()
        return checksum
    }
    
}
