

//
//  DateExtension.swift
//
//  Created by Joden on 8/25/16.
//  Copyright © 2016 QianDai, Inc. All rights reserved.
//

import Foundation

extension Date {
    public static var after30DaysString: String {
        return stringOfTime(date: Date().addingTimeInterval(60*60*24*30))
    }
    
    public static var todayString: String {
        let date = Date()
        return stringOfDay(date: date)
    }
    
    public static var tomorrowString: String {
        let date = Date().addingTimeInterval(60*60*24)
        return stringOfDay(date: date)
    }
    
    public static var lastDayString: String {
        let date = Date().addingTimeInterval(-60*60*24)
        return stringOfDay(date: date)
    }
    
    public static var longBeginDayString: String {
        let date = Date(timeIntervalSince1970: 0)
        return stringOfDay(date: date)
    }
    
    public static var thisMonthString: String {
        return stringOfMonth(date: Date())
    }
    
    public static var longBeginMonthString: String {
        return stringOfMonth(date: Date(timeIntervalSince1970: 0))
    }
    
    public var tomorrowDayString: String {
        let date = self.addingTimeInterval(60*60*24)
        return Date.stringOfDay(date: date)
    }
    
    public static func dateFromString(date: String) -> Date {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        fmt.calendar = Calendar(identifier: .iso8601)
        return fmt.date(from: date)! as Date
    }
    
    public static func timeFromString(time: String) -> Date {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fmt.calendar = Calendar(identifier: .iso8601)
        return fmt.date(from: time)! as Date
    }
    
    public static func stringOfDay(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let string = fmt.string(from: date as Date)
        return string
    }
    
    public static func stringOfMonth(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM"
        let string = fmt.string(from: date as Date)
        return string
    }
    
    public static func stringOfTime(date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let string = fmt.string(from: date as Date)
        return string
    }
}
