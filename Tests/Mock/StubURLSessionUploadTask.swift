import Foundation

public final class StubURLSessionUploadTask: URLSessionUploadTask {
    
    public let onResume: () -> ()
    
    public init(onResume: @escaping () -> ()) {
        self.onResume = onResume
    }
    
    override public func resume() {
        onResume()
    }
}
