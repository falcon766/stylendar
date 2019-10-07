//
//  STSelector.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 02/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftDate

/**
 *  The main data model which powers the Stylendar.
 *
 *  Observation: in every function, the `section` refers solely to the table view's section.
 */
class STSelector {
 
    /**
     *  Used to render more efficiently the cells.
     */
    var holder = STHolder()
    
    /**
     *  They are used as temporary holders for different interactions (tapping a polaroid to upload an image there for instance).
     */
    var tableIndexPath: IndexPath?
    var collectionIndexPath: IndexPath?
    var path: String?
    
    /**
     *  The allowed interval for the stylendar begins with the account creation date and ends 3 months after the current date.
     */
    var createdAt: String?

    var start: Date {
        get {
            guard
                let createdAt = createdAt,
                let date = createdAt.date(format: .iso8601(options: .withInternetDateTime), fromRegion: .GMT())?.absoluteDate
            else { return Date() - (Date().weekday-1).days }
            return (date - (date.weekday-1).days).startOfDay
        }
    }
    
    lazy var end: Date = {
        return Date() + 3.months
    }()
    
    /**
     *  Returns the total amount of days between the start and the end.
     */
    var totalDays: Int = 0

    
    /**
     *  Sugar property to know in advance the index of the today's cell.
     */
    var todayIndex: Int = 0
    
    /**
     *  Ante-generating the data. Check out @STHolder for more information.
     */
    func gen() {
        var difference: TimeInterval = 0
        difference = end - start
        guard let days = difference.in(.day) else { return }
        totalDays = days

        for i in 0..<totalDays {
            let date = start + i.days
            
            let year = date.year; let month = date.month; let day = date.day
            holder.paths[i] = STDate.format(year, month, day)
            holder.printables[i] = DateFormatter().shortMonthSymbols[month-1].uppercased() + " " + "\(day)"
        }
        
        /**
         *  We don't wish to verify the today index on every collection view cell display.
         */
        difference = Date() - start
        guard let todayIndexValue = difference.in(.day) else { return }
        todayIndex = todayIndexValue
    }
    
    
    /**
     *  Clears the index paths and the path.
     */
    func clear() {
        tableIndexPath = nil
        collectionIndexPath = nil
        path = nil
    }
}

extension STSelector {
    
    /**
     *  Appends the given indexPaths to the selector.
     */
    func append(tableIndexPath: IndexPath, collectionIndexPath: IndexPath, path: String) {
        self.tableIndexPath = tableIndexPath
        self.collectionIndexPath = collectionIndexPath
        self.path = path
    }

    /**
     *  Get the table and collection index paths for today.
     *
     *  Important observation: we have to include the adjustment to the system, because without it the index will be `adjustment` days in the past (the system always displays
     *  the polaroids starting from Sunday, no matter what month is then, eg 30 Jul, 31 Jul, 1 Aug etc).
     */
    func indexPathsForToday() -> [IndexPath]? {
        return indexPaths(for: Date())
    }
    func indexPaths(for date: Date) -> [IndexPath]? {
        let difference = date - start
        guard let days = difference.in(.day) else { return nil }
        
        /**
         *  The `tableIndexPath` row is the number of days divided by 7 because the data is displayed on sets of 7 days (weeks).
         *
         *  The `collectionIndexPath` row is the number of days divided by 7 then modulo 7 because the collection view cell is the
         *  weekday. Be careful, we firstly have to divide by 7 to know the current week, then the day. We can't get the weekday directy
         *  by applying modulo 7.
         */
        let tableIndexPath = IndexPath(row: days / 7, section: 0)
        let collectionIndexPath = IndexPath(item: days % 7, section: 0)
        return [tableIndexPath, collectionIndexPath]
    }
}
