//
//  STDate.swift
//  Stylendar
//
//  Created by Paul Berg on 23/03/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftDate

/**
    The default date format used on Stylendar.
 */
enum STDateFormat {
    case `default`, selector, american
    
    var rawValue: DateFormat {
        get {
            switch self {
            case .default:
                return .custom("yyyy/MM/dd")
            case .selector:
                return .custom("MM-yyyy")
            case .american:
                return .custom("MMM dd, yyyy")
            }
        }
    }
}

class STDate {
    /**
     *  Get now() as string with a given format.
     */
    class func now(_ format: DateFormat) -> String {
        return Date().string(format: format)
    }
    
    /**
     *  A sugar method to convert a date string to a fully formatted one:
     *
     *  1. Has the format YYYY/MM/DD
     *  2. It doesn't contain any Firebase-imposing prefix ('y', 'm' or 'd').
     *  3. It's zero-padded when the day or hte month is lower than 0.
     */
    class func format(_ year: String, _ month: String, _ day: String) -> String {
        guard
            let yearInt = Int(year.replacingOccurrences(of: "y", with: "")),
            let monthInt = Int( month.replacingOccurrences(of: "m", with: "")),
            let dayInt = Int(day.replacingOccurrences(of: "d", with: ""))
            else { return "undefined" }
        
        return format(yearInt, monthInt, dayInt)
    }
    
    class func format(_ year: Int, _ month: Int, _ day: Int) -> String {
        let formattedYear = String(year).replacingOccurrences(of: "y", with: "")
        let formattedMonth =  String(format: "%02d", month).replacingOccurrences(of: "m", with: "")
        let formattedDay = String(format: "%02d", day).replacingOccurrences(of: "d", with: "")

        return formattedYear + "/" + formattedMonth + "/" + formattedDay
    }
    
    /**
     *  A sugar method to convert a path-like string (kSTDateFormatDefault) into an american formatted date string.
     *
     *  This is called `americanized` because the outputed format is the USA standard.
     */
//   class func americanize(date: Date) -> String? {
//        return americanize(date)
//    }
    class func americanize(_ date: String) -> String? {
        let parts = date.components(separatedBy: "/")
        let year = parts[0]
        guard let month = Int(parts[1]) else { return nil }
        let day = parts[2]
        return DateFormatter().shortMonthSymbols[month-1].localizedCapitalized.replacingOccurrences(of: ".", with: "").uppercased(with: .current) + " " + day + ", " + year
    }
}

extension Date {
    /**
     *  Returns the date with the 00:00 hour of the given date's day.
     */
    var startOfDay: Date {
        get {
            return Calendar.current.startOfDay(for: self)
        }
    }
    
    /**
     *  Returns the first day of the month.
     */
    var startOfMonth: Date {
        get {
            return startOf(component: .month)
        }
    }
    
    /**
     *  Returns the date with the 23:59 hour of the given date's day.
     */
    var endOfDay: Date? {
        get {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfDay)
        }
    }
    
    
    /**
     *  Returns the end day of the month.
     */
    var endOfMonth: Date {
        get {
            return endOf(component: .month)
        }
    }
}

extension DateInRegion {
    
    /**
     *  Returns the first day of the month.
     */
    var startOfMonth: DateInRegion {
        get {
            return startOf(component: .month)
        }
    }
    
    /**
     *  Returns the end day of the month.
     */
    var endOfMonth: DateInRegion {
        get {
            return endOf(component: .month)
        }
    }
}
