import Foundation

public protocol CalciferPathProvider {
    func calciferDirectory() -> String
    func calciferBinaryName() -> String
    func calciferBinaryPath() -> String
    func calciferChecksumFilePath() -> String
    func calciferEnvironmentFilePath() -> String
    func calciferBuildLogDirectory() -> String
    func launchAgentPlistPath(label: String) -> String
    func launchctlStandardOutPath() -> String
    func launchctlStandardErrorPath() -> String
}
