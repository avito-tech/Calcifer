import Foundation

public final class StubURLSessionDownloadTask: URLSessionDownloadTask {
    
    public let onResume: () -> ()
    
    public init(onResume: @escaping () -> ()) {
        self.onResume = onResume
    }
    
    override public func resume() {
        onResume()
    }
}
