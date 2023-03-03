import Foundation

extension Date {
    func format(_ format: String) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en".localized)
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = format
        
        return df.string(from: self)
    }
    
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }
    
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }
    
    var second: Int {
        Calendar.current.component(.second, from: self)
    }
}

extension Double {
    
    func transformToDate(_ offset: Double) -> Date {
        return Date(timeIntervalSince1970: self + offset)
    }
}
