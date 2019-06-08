import Foundation

public protocol CalciferPathProvider {
    func calciferDirectory() -> String
    func calciferBinaryName() -> String
    func calciferBinaryPath() -> String
    func calciferCheckumFilePath() -> String
    func calciferEnvironmentFilePath() -> String
    func calciferBuildLogDirectory() -> String
}
