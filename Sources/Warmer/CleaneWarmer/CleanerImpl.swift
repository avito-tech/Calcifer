import Foundation
import BuildProductCacheStorage
public final class CleanerImpl: Cleaner {
    
    enum OutdateStrategy {
        case accessDate(Date)
        case modificationDate(Date)
        case size(UInt64)
    }
    
    private let fileManager: FileManager
    
    public init(fileManager: FileManager) {
        self.fileManager = fileManager
    }

    public func clean(
        logsDirectory: String,
        buildLogDirectory: String,
        checksumDirectory: String,
        launchctlLogDirectory: String)
    {
        let sevenDaysAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        let hundredMegabytes: UInt64 = 100 * 1024 * 1024
        clearLogsDirectory(
            logsDirectory: logsDirectory,
            outdateStrategy: .modificationDate(sevenDaysAgo)
        )
        clearDirectory(
            at: checksumDirectory,
            files: true,
            outdateStrategy: .modificationDate(sevenDaysAgo)
        )
        clearDirectory(
            at: launchctlLogDirectory,
            files: true,
            outdateStrategy: .size(hundredMegabytes)
        )
    }
    
    private func clearLogsDirectory(logsDirectory: String, outdateStrategy: OutdateStrategy) {
        fileManager.enumerate(at: logsDirectory, files: false) { directory in
            clearDirectory(
                at: directory,
                files: true,
                outdateStrategy: outdateStrategy
            )
        }
    }
    
    private func clearDirectory(at path: String, files: Bool, outdateStrategy: OutdateStrategy) {
        let condition = obtainCondition(for: outdateStrategy)
        fileManager.enumerate(at: path, files: files) { elementPath in
            removeIfCondition(
                path: elementPath,
                condition: condition(elementPath)
            )
        }
    }
    
    private func obtainCondition(for strategy: OutdateStrategy) -> ((String) -> (Bool)) {
        switch strategy {
        case let .accessDate(date):
            return { path in
                guard let accessDate = try? self.fileManager.accessDate(at: path) else { return false }
                return accessDate < date
            }
        case let .modificationDate(date):
            return { path in
                guard let modificationDate = try? self.fileManager.modificationDate(at: path) else { return false }
                return modificationDate < date
            }
        case let .size(size):
            return { path in
                guard let fileSize = try? self.fileManager.fileSize(at: path) else { return false }
                return fileSize > size
            }
        }
    }
    
    private func removeIfCondition(path: String, condition: @autoclosure () -> (Bool)) {
        guard condition() else { return }
        try? fileManager.removeItem(atPath: path)
    }
    
}
