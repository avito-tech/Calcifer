import Foundation

protocol Checksummable: Hashable {
    var checksum: String { get }
}

struct FileChecksum: Checksummable {
    
    let filePath: String
    let checksum: String
    
}

struct TargetChecksum: Checksummable {
    
    let files: [FileChecksum]
    let checksum: String
    
}

struct ProjectChecksum: Checksummable {
    
    let targets: [TargetChecksum]
    let checksum: String
    
}

struct ProjChecksum: Checksummable {
    
    let projects: [ProjectChecksum]
    let checksum: String
    
}

extension Array where Element: Checksummable {
    
    func checksum() throws -> String {
        guard let checksum = try map({ $0.checksum }).joined().md5() else {
            throw ProjectChecksumCalculatorError.emptyChecksum
        }
        return checksum
    }
}
