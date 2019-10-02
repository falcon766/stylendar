//
//  STFeedData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 11/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate

class STFeedData {
    
    /**
     *  The posts have to be grouped in sections by dates. There were multiple ways to accomplish this, but we figured out the most efficient way is to pull
     *  a fixed number of posts from Firebase disregarding their dates. Therefore, we don't pull a fixed number of dates, because that would create an overflow
     *  items in certain scenarios (let's say in one date there are 1000 items) and the concept of infinite loading itself would break. Instead, we get 20 items
     *  at a time and group them locally.
     */
    var posts = [String: [STPost]]()
    var dates = [String]()
}

extension STFeedViewController {
    /**
     * Appends the pagination's required settings to power this view controller.
     */
    func appendPaginationData() {
        pagination.dataRound = 0
        pagination.itemsPerPage = 20
    }
}
