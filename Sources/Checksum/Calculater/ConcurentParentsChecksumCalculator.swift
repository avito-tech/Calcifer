import Foundation
import Toolkit

public final class ConcurentParentsChecksumCalculator: ChecksumCalculator {
    public init() {}
    
    public func calculate<ChecksumType: Checksum>(
        rootHolder: BaseChecksumHolder<ChecksumType>)
        throws -> ChecksumType
    {
        let calculated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try rootHolder
            .obtainNotCalculatedLeafs()
            .enumerateKeysAndObjects(options: .concurrent) { _, leaf, _ in
                try calculateSelfAndParents(holder: leaf, calculated: calculated)
        }
        return try rootHolder.obtainChecksum()
    }
    
    private func calculateSelfAndParents<ChecksumType: Checksum>(
        holder: BaseChecksumHolder<ChecksumType>,
        calculated: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        guard calculated.createIfNotExist(holder.name, holder).created else { return }
        guard !holder.calculated else { return }
        guard !holder.haveNotCalculatedChildren() else { return }
        _ = try holder.obtainChecksum()
        try holder.parents.values.enumerateObjects(options: .concurrent) { parent, _  in
            try calculateSelfAndParents(holder: parent, calculated: calculated)
        }
    }
}
