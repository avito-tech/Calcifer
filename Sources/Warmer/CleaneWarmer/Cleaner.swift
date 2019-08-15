import Foundation

public protocol Cleaner {
    func clean(
        logsDirectory: String,
        buildLogDirectory: String,
        checksumDirectory: String,
        launchctlLogDirectory: String
    )
}
