import Foundation
import ArgumentsParser
import XcodeProjCache

public extension Command {
    var cacheFactory: CacheFactory {
        return CacheFactoryImpl.shared
    }
}
