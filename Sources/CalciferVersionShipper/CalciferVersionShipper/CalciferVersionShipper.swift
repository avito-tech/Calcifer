import Foundation
import CalciferConfig

public protocol CalciferVersionShipper {
    func shipCalcifer(
        at path: String,
        config: CalciferShipConfig,
        completion: @escaping (Result<Void, Error>) -> ()
    ) throws
}
