import Foundation
import Checksum
import Toolkit

final class XcodeProjChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String : BaseChecksumHolder<ChecksumType>] {
        return projs
    }
    
    var projs = [String: ProjChecksumHolder<ChecksumType>]()
    
    private let fullPathProvider: FileElementFullPathProvider
    private let checksumProducer: URLChecksumProducer<ChecksumType>
    private let cache = ThreadSafeDictionary<String, TargetChecksumHolder<ChecksumType>>()
    private let lock =  NSLock()
    
    init(
        name: String,
        fullPathProvider: FileElementFullPathProvider,
        checksumProducer: URLChecksumProducer<ChecksumType>)
    {
        self.fullPathProvider = fullPathProvider
        self.checksumProducer = checksumProducer
        super.init(
            name: name,
            parent: nil
        )
    }
    
    override func calculateChecksum() throws -> ChecksumType {
        return try projs.values.sorted().map {
            try $0.obtainChecksum()
        }.aggregate()
    }
    
    func reflectUpdate(updateModel: XcodeProjUpdateModel) throws {
        let projectUpdateModelsDictionary = [updateModel.xcodeProj.pbxproj]
            .map { proj in
                ProjUpdateModel(
                    proj: proj,
                    sourceRoot: updateModel.sourceRoot,
                    cache: cache
                )
            }.toDictionary { $0.name }
        let shouldInvalidate = try projectUpdateModelsDictionary.update(
            childrenDictionary: &projs,
            update: { projChecksumHolder, projUpdateModel in
                try projChecksumHolder.reflectUpdate(updateModel: projUpdateModel)
            }, buildValue: { projUpdateModel in
                ProjChecksumHolder(
                    name: projUpdateModel.name,
                    parent: self,
                    fullPathProvider: fullPathProvider,
                    checksumProducer: checksumProducer
                )
            }
        )
        if shouldInvalidate {
            invalidate()
        }
    }
    
}
