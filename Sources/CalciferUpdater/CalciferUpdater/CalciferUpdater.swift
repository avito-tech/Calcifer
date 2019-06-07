import Foundation
import CalciferConfig

public protocol CalciferUpdater {
    func updateCalcifer(
        config: CalciferUpdateConfig,
        completion: @escaping (Result<URL, Error>) -> ()
    ) throws
}
