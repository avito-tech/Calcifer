import Foundation

extension Date {
    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    public func string() -> String {
        let dateFormatter = Date.dateFormatter
        return dateFormatter.string(from: self)
    }
}
