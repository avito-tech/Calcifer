import Foundation
import CalciferConfig

public protocol XcodeProjectBuilderOutputFilter {
    var buildLogLevel: BuildLogLevel { get set }
    func filter(data: Data) -> Data?
}
