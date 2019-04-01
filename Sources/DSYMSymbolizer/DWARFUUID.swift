import Foundation

public struct DWARFUUID: Equatable, Hashable {
    public let uuid: UUID
    public let architecture: String
    
    public init(uuid: UUID, architecture: String) {
        self.uuid = uuid
        self.architecture = architecture
    }
}
