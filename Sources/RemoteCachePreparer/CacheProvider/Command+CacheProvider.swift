import Foundation
import ArgumentsParser
import XcodeProjCache

public extension Command {
    var cacheProvider: CacheProvider {
        return CacheProviderImpl.shared
    }
}
