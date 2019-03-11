import Foundation

public extension String {
    
    public func chomp(_ count: Int = 1) -> String {
        if count >= 0 && count <= self.count {
            let indexStartOfText = self.index(self.startIndex, offsetBy: count)
            return String(self[indexStartOfText...])
        }
        return ""
    }
    
    public func chop(_ count: Int = 1) -> String {
        if count >= 0 && count <= self.count {
            let indexEndOfText = self.index(self.endIndex, offsetBy: -count)
            return String(self[..<indexEndOfText])
        }
        return ""
    }
}
