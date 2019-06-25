import Foundation
import Toolkit

public final class CalciferPathProviderStub: CalciferPathProviderImpl {
    
    public var stubedCalciferDirectory: String?
    
    override public func calciferDirectory() -> String {
        guard let stubedCalciferDirectory = stubedCalciferDirectory else {
            return super.calciferDirectory()
        }
        return stubedCalciferDirectory
    }

}
