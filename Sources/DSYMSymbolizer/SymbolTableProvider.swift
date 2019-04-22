import Foundation

public protocol SymbolTableProvider: class {
    func obtainSymbolTable(binaryPath: String) throws -> [String]
}
