import Foundation

protocol ChecksumObject: Hashable {
    var checksum: String { get }
}

struct FileChecksum: ChecksumObject {
    
    let filePath: String
    let checksum: String
    
}

struct TargetChecksum: ChecksumObject {
    
    let files: [FileChecksum]
    let checksum: String
    
}

struct ProjectChecksum: ChecksumObject {
    
    let targets: [TargetChecksum]
    let checksum: String
    
}

struct ProjChecksum: ChecksumObject {
    
    let projects: [ProjectChecksum]
    let checksum: String
    
}

extension Array where Element: ChecksumObject {
    
    func checksum() throws -> String {
        guard let checksum = try map({ $0.checksum }).joined().md5() else {
            throw ProjectChecksumCalculatorError.emptyChecksum
        }
        return checksum
    }
}
