import Foundation

public struct CacheHitStatistic {
    public let hit: [String]
    public let miss: [String]
    public let all: [String]
    
    public init(hit: [String], miss: [String], all: [String]) {
        self.hit = hit
        self.miss = miss
        self.all = all
    }
}
