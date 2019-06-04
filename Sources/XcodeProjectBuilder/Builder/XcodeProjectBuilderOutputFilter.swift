import Foundation
import CalciferConfig

public protocol XcodeProjectBuilderOutputFilter {
    func filter(data: Data) -> Data?
}
