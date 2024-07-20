import Foundation

extension Date {
    static func fromTimeStamp(from timeStamp: Int?) -> Date? {
        guard let timeStamp else {return nil}
        return Date(timeIntervalSince1970: Double(timeStamp))
    }

    static func fromString(string: String?) -> Date? {
        guard let string else {return nil}
        return ISO8601DateFormatter().date(from: string)
    }
    
    func string() -> String {
        return ISO8601DateFormatter().string(from: self)
    }
    
    func getTimestamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }

    func getDayAndMonth() -> (String, String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: self)
        return (day, month)
    }
 }
