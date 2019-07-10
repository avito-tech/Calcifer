import Foundation
import Checksum
import XcodeProj
import PathKit

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Xcode models structure:                                                                                                //
// XcodeProj - root, represent *.xcodeproj file. It contains pbxproj file represented by Proj (Look below) and xcschemes. //
// Proj - represent project.pbxproj file. It contains all references to objects - projects, files, groups, targets etc.   //
// Project - represent build project. It contains build settings and targets.                                             //
// Target - represent build target. It contains build phases. For example source build phase.                             //
// File - represent source file. Can be obtained from source build phase.                                                 //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
final class FileChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {

    private let fileURL: URL
    private let checksumProducer: URLChecksumProducer<ChecksumType>
    
    override var children: [String: BaseChecksumHolder<ChecksumType>] {
        return [:]
    }
    
    init(
        fileURL: URL,
        parent: BaseChecksumHolder<ChecksumType>,
        checksumProducer: URLChecksumProducer<ChecksumType>)
    {
        self.fileURL = fileURL
        self.checksumProducer = checksumProducer
        super.init(name: fileURL.path, parent: parent)
    }
    
    override func calculateChecksum() throws -> ChecksumType {
        return try checksumProducer.checksum(input: fileURL)
    }
    
    func reflectUpdate(updateModel: URL) throws {
        guard calculated == true else {
            return
        }
        let newChecksum = try checksumProducer.checksum(input: updateModel)
        let currentChecksum = try obtainChecksum()
        if newChecksum != currentChecksum {
            updateState(checksum: newChecksum)
        }
    }
}
