import Foundation
import CalciferConfig

public final class XcodeProjectBuilderOutputFilterImpl: XcodeProjectBuilderOutputFilter {
    
    public var buildLogLevel: BuildLogLevel = .info
    
    public init() {}
    
    private enum Filter: String {
        case note = "note:"
        case warning = "warning:"
        case error = "error:"
    }
    
    public func filter(data: Data) -> Data? {
        switch buildLogLevel {
        case .verbose:
            return data
        case .info:
            return filter(
                data,
                containList: [
                    Filter.note.rawValue,
                    Filter.warning.rawValue,
                    Filter.error.rawValue,
                ]
            )
        case .warning:
            return filter(
                data,
                containList: [
                    Filter.warning.rawValue,
                    Filter.error.rawValue,
                ]
            )
        case .error:
            return filter(
                data,
                containList: [
                    Filter.error.rawValue,
                ]
            )
        }
    }
    
    private func filter(_ data: Data, containList: [String]) -> Data {
        guard let string = String(data: data, encoding: .utf8) else {
            return data
        }
        let lines = string.split(separator: "\n")
        var filtredLines = [String]()
        for line in lines {
            for contain in containList {
                if line.contains(contain) {
                    filtredLines.append(String(line))
                    continue
                }
            }
        }
        let filtredString = filtredLines.joined(separator: "\n")
        return Data(filtredString.utf8)
    }
}
