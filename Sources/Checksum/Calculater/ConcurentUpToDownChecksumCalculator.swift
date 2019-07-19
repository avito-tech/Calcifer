import Foundation
import Toolkit

public final class ConcurentUpToDownChecksumCalculator: ChecksumCalculator {
    
    public init() {}
    
    public func calculate<ChecksumType: Checksum>(
        rootHolder: BaseChecksumHolder<ChecksumType>)
        throws -> ChecksumType
    {
        let calculated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try upToDownChecksumCalculate(
            holder: rootHolder,
            calculated: calculated,
            concurent: true
        )
        return try rootHolder.obtainChecksum()
    }
    
    private func upToDownChecksumCalculate<ChecksumType: Checksum>(
        holder: BaseChecksumHolder<ChecksumType>,
        calculated: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>,
        concurent: Bool) throws
    {
        guard calculated.createIfNotExist(holder.name, holder).created else { return }
        guard !holder.calculated else { return }
        let children = holder.children
        if children.count > 1 && concurent {
            try children.enumerateKeysAndObjects(options: .concurrent) { _, child, _ in
                try upToDownChecksumCalculate(
                    holder: child,
                    calculated: calculated,
                    concurent: false
                )
            }
        } else {
            for child in children.values {
                try upToDownChecksumCalculate(
                    holder: child,
                    calculated: calculated,
                    concurent: concurent
                )
            }
        }
        _ = try holder.obtainChecksum()
    }
}
