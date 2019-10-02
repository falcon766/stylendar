//
//  STStylendarData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

class STStylendarData {
    /**
     *  This view controller can also be public, not only the first tab which is the user's own stylendar.
     */
    var user = STUser()
    
    /**
     *  The following is retrieved from Firebase.
     */
    var createdAt: String?
    var isUserFollowed: STFollowState = .notfollowing
    var isStylendarPublic: Bool = true
    
    /**
     *  Tells if the image exists in the database.
     *
     *  @nil: it doesn't.
     *  @true: it does.
     *
     *  We use nil, not false, because we don't want to overflow the realtime database with negative boolean values when the non-existence implies the same logic.
     */
    var urls = [String:String]()

    /**
     *  Tells the selected month and year. Default are the ones at the current moment.
     */
    var selector = STSelector()
    
    /**
     *  The simple list of months.
     */
    var monthList: [String] {
        get {
            return DateFormatter().shortMonthSymbols
        }
    }
    
    /**
     *  The simple list of years from 2000 to 2050.
     */
    lazy var yearList: [String] = {
        let yearIntList = stride(from: 2000, to: 2050, by: 1)
    
        var yearList = [String]()
        var name: String? = STUser.shared.name.first

        for year in yearIntList {
            yearList.append("\(year)")
        }
        return yearList
    }()
    
    /**
     *  Sugar method to initialize quickly.
     */
    public init() {}
    public init(user: STUser) {
        self.user = user
    }
}
