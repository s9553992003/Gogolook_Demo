//
//  TimeTools.swift
//  Gogolook_Demo
//
//  Created by Helios Chen on 2022/7/21.
//

import UIKit

class TimeTools {

    static let instance = TimeTools()
    lazy var start = NSDate()

    func ltzAbbrev() -> String {return NSTimeZone.local.abbreviation() ?? "" }

    func utcToLocalDate(dateStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+00:00"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy/MM/dd"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
}
