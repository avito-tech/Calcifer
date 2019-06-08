import Foundation

public protocol CalciferBinaryInstaller {
    func install(binaryPath: String, destinationPath: String) throws
}
