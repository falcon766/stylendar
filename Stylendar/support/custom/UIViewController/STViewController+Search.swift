//
//  STViewController+Search.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 20/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Alamofire

/**
 *  Used to interact with the UI of the page but constantly knowing which is the state of the data.
 */
@objc enum STSearchableViewControllerState: Int {
    case startup = 0,
    buffering = 1,
    idle = 2
}

/**
 *  A simple, yet effective protocol which abstracts away some vars for a searchable view controller. It must have tha ability to cancel the ongoing requests
 *  when the following scenario occurs:
 *
 *  1. A request, let's call it A, is already ongoing for a given query string typed in the search box.
 *  2. However, the user types some new text before the last request was finished, which means he wants to see data for something else. Request B has to be started.
 *  3. Thus, let's cancel A and kickstart B to accommodate the user's needs.
 *
 *
 *  Observations:
 *
 *  1. Happens most often on low-signal internet connections.
 *  2. But not only, large datasets (eg: querying for "a") could yield this scenario.
 */
protocol STSearchableViewController: class {
    
    /**
     *  Tells the state of the search.
     */
    var state: STSearchableViewControllerState { get set }
    
    /**
     *  Sugar property to ease the access of the pagination, because, in the cast of a search system, it's a must have.
     */
    var pagination: STPagination { get set }
}
