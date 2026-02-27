import Foundation

extension Date {
    var monthAndDay: String {
        DateFormatter.monthAndDay.string(from: self)
    }

    var year: String {
        DateFormatter.year.string(from: self)
    }
}

private extension DateFormatter {
    static let monthAndDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM\ndd"
        return formatter
    }()

    static let year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
}
