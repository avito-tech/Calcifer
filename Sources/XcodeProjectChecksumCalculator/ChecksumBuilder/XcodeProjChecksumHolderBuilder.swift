import Foundation
import XcodeProjCache
import XcodeProj
import Checksum
import PathKit
import Toolkit

protocol XcodeProjChecksumCache {
    associatedtype ChecksumType: Checksum
    func obtain(for projectPath: String) -> XcodeProjChecksumHolder<ChecksumType>?
    func save(_ xcodeProjChecksumHolder: XcodeProjChecksumHolder<ChecksumType>, for projectPath: String)
}

final class XcodeProjChecksumCacheImpl: XcodeProjChecksumCache {
    
    let storage = BaseKeyValueStorage<String, XcodeProjChecksumHolder<BaseChecksum>>()
    
    public static let shared: XcodeProjChecksumCacheImpl = {
        return XcodeProjChecksumCacheImpl()
    }()
    
    init() {}
    
    func obtain(for projectPath: String) -> XcodeProjChecksumHolder<BaseChecksum>? {
        return storage.obtain(for: projectPath)
    }
    
    func save(_ xcodeProjChecksumHolder: XcodeProjChecksumHolder<BaseChecksum>, for projectPath: String) {
        storage.addValue(xcodeProjChecksumHolder, for: projectPath)
    }
    
    
}

final class XcodeProjChecksumHolderBuilder<ChecksumCache: XcodeProjChecksumCache> {
    
    private let xcodeProjCache: XcodeProjCache
    private let xcodeProjChecksumCache: ChecksumCache
    private let checksumProducer: URLChecksumProducer<ChecksumCache.ChecksumType>
    private let fullPathProvider: FileElementFullPathProvider
    
    init(
        xcodeProjCache: XcodeProjCache,
        xcodeProjChecksumCache: ChecksumCache,
        checksumProducer: URLChecksumProducer<ChecksumCache.ChecksumType>,
        fullPathProvider: FileElementFullPathProvider)
    {
        self.xcodeProjCache = xcodeProjCache
        self.xcodeProjChecksumCache = xcodeProjChecksumCache
        self.checksumProducer = checksumProducer
        self.fullPathProvider = fullPathProvider
    }
    
    func build(xcodeProj: XcodeProj, projectPath: String) throws -> XcodeProjChecksumHolder<ChecksumCache.ChecksumType> {
        
        let sourceRoot = Path(components: Array(Path(projectPath).components.dropLast()))
        let xcodeProjChecksumHolder = obtainXcodeProjChecksumHolder(for: projectPath)
        let xcodeProjUpdateModel = XcodeProjUpdateModel(
            xcodeProj: xcodeProj,
            projectPath: projectPath,
            sourceRoot: sourceRoot,
            updateIdentifier: UUID().uuidString
        )
        try xcodeProjChecksumHolder.reflectUpdate(updateModel: xcodeProjUpdateModel)
        return xcodeProjChecksumHolder
    }
    
    private func obtainXcodeProjChecksumHolder(for projectPath: String)
        -> XcodeProjChecksumHolder<ChecksumCache.ChecksumType>
    {
        guard let cached = xcodeProjChecksumCache.obtain(for: projectPath) else {
            let xcodeProjChecksumHolder = XcodeProjChecksumHolder<ChecksumCache.ChecksumType>(
                name: projectPath,
                fullPathProvider: fullPathProvider,
                checksumProducer: checksumProducer
            )
            xcodeProjChecksumCache.save(xcodeProjChecksumHolder, for: projectPath)
            return xcodeProjChecksumHolder
        }
        return cached
    }
}
