import Foundation
import Checksum
import xcodeproj
import PathKit
import Toolkit

public final class XcodeProjCacheImpl: XcodeProjCache {
    
    private let queue = DispatchQueue(label: "XcodeProjCache")
    private let checksumProducer: BaseURLChecksumProducer
    private var cache = [String: XcodeProjCacheValue<BaseChecksum>]()
    private let fileManager: FileManager
    
    public static let shared: XcodeProjCacheImpl = {
        let fileManager = FileManager.default
        let checksumProducer = BaseURLChecksumProducer(fileManager: fileManager)
        return XcodeProjCacheImpl(
            fileManager: fileManager,
            checksumProducer: checksumProducer
        )
    }()
    
    private init(
        fileManager: FileManager,
        checksumProducer: BaseURLChecksumProducer)
    {
        self.fileManager = fileManager
        self.checksumProducer = checksumProducer
    }
    
    public func obtainXcodeProj(projectPath: String) throws -> XcodeProj {
        return try queue.sync {
            
            guard let modificationDate = obtainModificationDate(for: projectPath) else {
                throw XcodeProjCacheError.emptyModificationDate(
                    path: obtainPbxprojPath(for: projectPath)
                )
            }
            
            if let cacheValue = cache[projectPath],
                cacheValue.modificationDate == modificationDate {
                return cacheValue.xcodeProj
            }
            
            let checksum = try obtainChecksum(for: projectPath)
            if let cacheValue = cache[projectPath],
                cacheValue.checksum == checksum {
                return cacheValue.xcodeProj
            }
            
            let path = Path(projectPath)
            let xcodeProj = try XcodeProj(path: path)
            cache[projectPath] = XcodeProjCacheValue(
                xcodeProj: xcodeProj,
                checksum: checksum,
                modificationDate: modificationDate
            )
            return xcodeProj
        }
    }
    
    private func obtainChecksum(for projectPath: String) throws -> BaseChecksum {
        let pbxprojPath = obtainPbxprojPath(for: projectPath)
        let pbxprojURL = URL(fileURLWithPath: pbxprojPath)
        let checksum = try checksumProducer.checksum(input: pbxprojURL)
        return checksum
    }
    
    private func obtainModificationDate(for projectPath: String) -> Date? {
        let pbxprojPath = obtainPbxprojPath(for: projectPath)
        return fileManager.modificationDate(at: pbxprojPath)
    }
    
    private func obtainPbxprojPath(for projectPath: String) -> String {
        let pbxprojPath = projectPath.appendingPathComponent("project.pbxproj")
        return pbxprojPath
    }
    
}
