import Foundation

public protocol CalciferPathProvider {
    func calciferDirectory() -> String
    func calciferBinaryName() -> String
    func calciferBinaryPath() -> String
    func calciferLogsDirectory() -> String
    func calciferChecksumDirectory() -> String
    func calciferChecksumFilePath(for date: Date) -> String
    func calciferEnvironmentFilePath() -> String
    func calciferBuildLogDirectory() -> String
    func launchAgentPlistPath(label: String) -> String
    func launchctlLogDirectory() -> String
    func launchctlStandardOutPath() -> String
    func launchctlStandardErrorPath() -> String
}
