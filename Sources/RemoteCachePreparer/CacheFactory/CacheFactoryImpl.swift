import Foundation
import XcodeProjectChecksumCalculator
import XcodeProjCache
import Checksum

public final class CacheFactoryImpl: CacheFactory {
    
    // Can be changed in tests
    static var sharedBuild: () -> (CacheFactory) = {
        CacheFactoryImpl()
    }
    
    public static let shared: CacheFactory = {
        sharedBuild()
    }()
    
    private init() {}
    
    public lazy var fileManager: FileManager = {
        FileManager.default
    }()
    
    public lazy var baseURLChecksumProducer: BaseURLChecksumProducer = {
        BaseURLChecksumProducer(fileManager: fileManager)
    }()
    
    public lazy var xcodeProjCache: XcodeProjCache = {
        XcodeProjCacheImpl(
            fileManager: fileManager,
            checksumProducer: baseURLChecksumProducer
        )
    }()
    
    public lazy var baseXcodeProjChecksumCache: BaseXcodeProjChecksumCache = {
        XcodeProjChecksumCacheImpl()
    }()
    
    lazy public var artifactBuildSourcePathCache: ArtifactBuildSourcePathCache = {
        ArtifactBuildSourcePathCacheImpl()
    }()
    
}
