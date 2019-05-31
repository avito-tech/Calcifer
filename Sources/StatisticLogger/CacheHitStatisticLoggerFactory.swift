import Foundation
import GraphiteClient
import Toolkit
import IO

public final class CacheHitStatisticLoggerFactory {
    
    public init() {}
    
    public func createGraphiteCacheHitStatisticLogger(
        host: String,
        port: Int,
        rootKey: String)
        throws -> CacheHitStatisticLogger
    {
        let client = try createGraphiteClient(
            host: host,
            port: port
        )
        let rootKeyArray = rootKey.split(separator: ".").map { String($0) }
        return GraphiteCacheHitStatisticLogger(
            client: client,
            rootKey: rootKeyArray
        )
    }
    
    private func createGraphiteClient(host: String, port: Int) throws -> GraphiteClient {
        let streamProvider = NetworkSocketOutputStreamProvider(
            host: host,
            port: port
        )
        let easyOutputStream = EasyOutputStream(
            outputStreamProvider: streamProvider,
            errorHandler: { stream, error in
                Logger.error("Graphite stream error: \(error)")
            },
            streamEndHandler: { stream in
                Logger.warning("Graphite stream has been closed")
            }
        )
        try easyOutputStream.open()
        return GraphiteClient(
            easyOutputStream: easyOutputStream
        )
    }

}
