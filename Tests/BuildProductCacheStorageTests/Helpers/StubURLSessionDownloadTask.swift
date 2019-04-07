import Foundation

final class StubURLSessionDownloadTask: URLSessionDownloadTask {
    
    let onResume: () -> ()
    
    init(onResume: @escaping () -> ()) {
        self.onResume = onResume
    }
    
    override func resume() {
        onResume()
    }
}
