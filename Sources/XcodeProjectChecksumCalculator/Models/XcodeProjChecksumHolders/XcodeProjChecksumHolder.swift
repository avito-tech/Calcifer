import Foundation
import Checksum

class XcodeProjChecksumHolder<ChecksumType: Checksum>: BaseChecksumHolder<ChecksumType> {
    
    override var children: [String : BaseChecksumHolder<ChecksumType>] {
        return projs
    }
    
    var projs = [String: ProjChecksumHolder<ChecksumType>]()
    
    init(name: String) {
        super.init(
            name: name,
            parent: nil
        )
    }
    
    override public func calculateChecksum<ChecksumProducer: URLChecksumProducer>(checksumProducer: ChecksumProducer)
        throws -> ChecksumType
        where ChecksumProducer.ChecksumType == ChecksumType
    {
        return try projs.values.sorted().map {
            try $0.obtainChecksum(checksumProducer: checksumProducer)
        }.aggregate()
    }
    
    func reflectUpdate(updateModel: XcodeProjUpdateModel) throws {
        let projectUpdateModelsDictionary = [updateModel.xcodeProj.pbxproj]
            .map { proj in
                ProjUpdateModel(
                    proj: proj,
                    sourceRoot: updateModel.sourceRoot
                )
            }.keyValue { $0.name }
        let shouldInvalidate = try projectUpdateModelsDictionary.update(
            childrenDictionary: &projs,
            update: { projChecksumHolder, projUpdateModel in
                try projChecksumHolder.reflectUpdate(updateModel: projUpdateModel)
            }, buildValue: { projUpdateModel in
                ProjChecksumHolder(
                    name: projUpdateModel.name,
                    parent: self
                )
            }
        )
        if shouldInvalidate {
            invalidate()
        }
    }
    
}
