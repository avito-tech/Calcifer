import Foundation
import XcodeProj
import Checksum
import PathKit

//final class FileChecksumHolderBuilder<ChecksumProducer: URLChecksumProducer> {
//
//    let fullPathProvider: FileElementFullPathProvider
//
//    init(fullPathProvider: FileElementFullPathProvider) {
//        self.fullPathProvider = fullPathProvider
//    }
//
//    func build(
//        parent: TargetChecksumHolder<ChecksumProducer.ChecksumType>,
//        file: PBXFileElement,
//        sourceRoot: Path)
//        throws -> FileChecksumHolder<ChecksumProducer.ChecksumType>
//    {
//        let filePath = try fullPathProvider.fullPath(for: file, sourceRoot: sourceRoot)
//        return FileChecksumHolder(
//            fileURL: filePath.url,
//            parent: parent
//        )
//    }
//
//}
