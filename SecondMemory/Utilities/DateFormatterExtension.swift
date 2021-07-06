//
//  DateFormatterExtension.swift
//  SecondMemory
//
//  Created by yum on 2021/07/05.
//

import Foundation

extension DateFormatter {
    func dbString(from: Date) -> String {
        self.calendar = Calendar(identifier: .gregorian)
        self.locale = Locale(identifier: "ja_JP")
        self.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        self.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        
        return self.string(from: from)
    }
}
