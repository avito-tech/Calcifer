import Foundation
import GraphiteClient
import IO

final class CustomOutputStreamProvider: OutputStreamProvider {
    
    private let outputStream: OutputStream
    
    init(outputStream: OutputStream) {
        self.outputStream = outputStream
    }
    
    func createOutputStream() throws -> OutputStream {
        return outputStream
    }
}
