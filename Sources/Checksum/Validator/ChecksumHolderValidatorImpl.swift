import Foundation
import Checksum
import Toolkit

public final class ChecksumHolderValidatorImpl: ChecksumHolderValidator {
    
    public init() {}
    
    public func validate<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        try validateAllChecksumCalculated(holder)
        try validateChecksumMatch(holder)
        try validateUniqueness(holder)
    }
    
    private func validateAllChecksumCalculated<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        let validated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validateAllChecksumCalculated(holder, validated: validated)
    }
    
    private func validateAllChecksumCalculated<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>,
        validated: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        guard validated.read(holder.uniqIdentifier) == nil else { return }
        validated.write(holder, for: holder.uniqIdentifier)
        guard holder.calculated else {
            throw ChecksumError.notCalculatedChecksum(name: holder.name)
        }
        for child in holder.children.values {
            try validateAllChecksumCalculated(child, validated: validated)
        }
    }
    
    private func validateChecksumMatch<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        let validated = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validateChecksumMatch(holder, validated: validated)
    }
    
    private func validateChecksumMatch<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>,
        validated: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        if validated.read(holder.name) != nil {
            return
        }
        if holder.children.isEmpty {
            return
        }
        let currentChecksum = try holder.obtainChecksum().stringValue
        let childrenChecksum = try holder.children.values.sorted().map {
            try $0.obtainChecksum()
        }.aggregate().stringValue
        if currentChecksum != childrenChecksum {
            throw ChecksumError.checksumMismatch(
                name: holder.name,
                currentChecksum: currentChecksum,
                childrenChecksum: childrenChecksum
            )
        }
        validated.write(holder, for: holder.name)
        try holder.children.enumerateKeysAndObjects(options: .concurrent) { _, child, _ in
            try validateChecksumMatch(child, validated: validated)
        }
    }
    
    private func validateUniqueness<ChecksumType: Checksum>(
        _ holder: BaseChecksumHolder<ChecksumType>)
        throws
    {
        let visited = ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>()
        try validateUniqueness(holder, visited: visited)
    }
    
    public func validateUniqueness<ChecksumType: Checksum>(
         _ holder: BaseChecksumHolder<ChecksumType>,
        visited: ThreadSafeDictionary<String, BaseChecksumHolder<ChecksumType>>)
        throws
    {
        let visitedHolder = visited.read(holder.name)
        if let visitedHolder = visitedHolder {
            if visitedHolder.uniqIdentifier != holder.uniqIdentifier {
                throw ChecksumError.dublicateChecksumHolder(name: holder.name)
            }
            return
        }
        visited.write(holder, for: holder.name)
        try holder.children.enumerateKeysAndObjects(options: .concurrent) { _, child, _ in
            try validateUniqueness(child, visited: visited)
        }
    }
}
