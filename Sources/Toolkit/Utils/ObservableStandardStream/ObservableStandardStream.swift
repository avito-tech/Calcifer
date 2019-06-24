import Foundation

public final class ObservableStandardStream {
    
    public static let shared = ObservableStandardStream(
        onOutputWrite: nil,
        onErrorWrite: nil
    )
    
    public var onOutputWrite: ((Data) -> ())?
    public var onErrorWrite: ((Data) -> ())?
    
    private init(
        onOutputWrite: ((Data) -> ())?,
        onErrorWrite: ((Data) -> ())?)
    {
        self.onOutputWrite = onOutputWrite
        self.onErrorWrite = onErrorWrite
    }
    
    private var standardOutput: FileHandle {
        return FileHandle.standardOutput
    }
    
    private var standardError: FileHandle {
        return FileHandle.standardError
    }
    
    public func writeOutput(_ data: Data) {
        onOutputWrite?(data)
        standardOutput.write(data)
    }
    
    public func writeError(_ data: Data) {
        onErrorWrite?(data)
        standardError.write(data)
    }
    
}
