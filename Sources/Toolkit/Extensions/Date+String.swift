import Foundation

extension Date {
    // TODO: If you find crash here, make it thread safe
    private static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    public func formattedString() -> String {
        let dateFormatter = Date.dateFormatter
        return dateFormatter.string(from: self)
    }
}
