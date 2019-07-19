import Foundation
import Toolkit

public final class ChecksumHolderValidatorImpl: ChecksumHolderValidator {
    
    public init() {}
    
    public func validate<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        try validateAllChecksumCalculated(holder)
        try validateChecksumMatchesSumOfChildrenChecksums(holder)
        try validateUniqueness(holder)
    }
    
    private func validateAllChecksumCalculated<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        let validated = ThreadSafeDictionary<UUID, BaseChecksumHolder<ChecksumType>>()
        try validateAllChecksumCalculated(holder, validated: validated)
    }
    
    private func validateAllChecksumCalculated<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>,
        validated: ThreadSafeDictionary<UUID, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        guard validated.createIfNotExist(holder.uniqIdentifier, holder).created else { return }
        guard holder.calculated else {
            throw ChecksumValidationError.notCalculatedChecksum(name: holder.name)
        }
        for child in holder.children.values {
            try validateAllChecksumCalculated(child, validated: validated)
        }
    }
    
    private func validateChecksumMatchesSumOfChildrenChecksums<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        let validated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validateChecksumMatchesSumOfChildrenChecksums(holder, validated: validated)
    }
    
    private func validateChecksumMatchesSumOfChildrenChecksums<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>,
        validated: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        guard validated.createIfNotExist(holder.name, holder).created else { return }
        if holder.children.isEmpty {
            return
        }
        let currentChecksum = try holder.obtainChecksum().stringValue
        let childrenChecksum = try holder.children.values.sorted().map {
            try $0.obtainChecksum()
        }.aggregate().stringValue
        if currentChecksum != childrenChecksum {
            throw ChecksumValidationError.checksumMismatch(
                name: holder.name,
                currentChecksum: currentChecksum,
                childrenChecksum: childrenChecksum
            )
        }
        try holder.children.enumerateKeysAndObjects(options: .concurrent) { _, child, _ in
            try validateChecksumMatchesSumOfChildrenChecksums(child, validated: validated)
        }
    }
    
    private func validateUniqueness<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        let visited = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validateUniqueness(holder, visited: visited)
    }
    
    private func validateUniqueness<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>,
        visited: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        let result = visited.createIfNotExist(holder.name, holder)
        guard result.created else {
            if result.value.uniqIdentifier != holder.uniqIdentifier {
                throw ChecksumValidationError.duplicateChecksumHolder(name: holder.name)
            }
            return
        }
        visited.write(holder, for: holder.name)
        try holder.children.enumerateKeysAndObjects(options: .concurrent) { _, child, _ in
            try validateUniqueness(child, visited: visited)
        }
    }
}
