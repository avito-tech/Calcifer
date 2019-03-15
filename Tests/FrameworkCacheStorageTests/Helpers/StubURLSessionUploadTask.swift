import Foundation

final class StubURLSessionUploadTask: URLSessionUploadTask {
    
    let onResume: () -> ()
    
    init(onResume: @escaping () -> ()) {
        self.onResume = onResume
    }
    
    override func resume() {
        onResume()
    }
}
