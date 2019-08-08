import Foundation
import XcodeProjectChecksumCalculator
import CalciferConfig
import Toolkit

public final class CleanWarmerFactory {
    
    private let fileManager: FileManager
    private let calciferPathProvider: CalciferPathProvider
    private let calciferConfigProvider: CalciferConfigProvider
    
    public init(
        fileManager: FileManager,
        calciferPathProvider: CalciferPathProvider,
        calciferConfigProvider: CalciferConfigProvider)
    {
        self.fileManager = fileManager
        self.calciferPathProvider = calciferPathProvider
        self.calciferConfigProvider = calciferConfigProvider
    }
    
    public func build() -> CleanWarmer {
        let cleaner = CleanerImpl(fileManager: fileManager)
        return CleanWarmer(
            cleaner: cleaner,
            calciferPathProvider: calciferPathProvider,
            calciferConfigProvider: calciferConfigProvider
        )
    }
}
