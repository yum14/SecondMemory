//
//  DateUtility.swift
//  SecondMemory
//
//  Created by yum on 2021/09/02.
//

import Foundation

class DateUtility {
    static func toString(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter.string(from: date)
    }
    
    static func toDate(dateString: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        return formatter.date(from: dateString)!
    }
}
