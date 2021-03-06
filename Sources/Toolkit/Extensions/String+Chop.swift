import Foundation

public extension String {
    
    func chomp(_ count: Int = 1) -> String {
        if !isEmpty && count <= self.count {
            let indexStartOfText = self.index(self.startIndex, offsetBy: count)
            return String(self[indexStartOfText...])
        }
        return ""
    }
    
    func chop(_ count: Int = 1) -> String {
        if !isEmpty && count <= self.count {
            let indexEndOfText = self.index(self.endIndex, offsetBy: -count)
            return String(self[..<indexEndOfText])
        }
        return ""
    }
}
