//
//  STViewController+Pagination.swift
//  Stylendar
//
//  Created by Paul Berg on 23/04/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import ObjectiveC


extension UIViewController {
    /**
     * We store the properties' keys here. Boilerplate code, but it's required.
     */
    struct Keys {
        static fileprivate var pagination: UInt8 = 0
    }
    
    
    /**
     * The object which incorporates all the states and properties to implement the pagination in a view controller.
     */
    var pagination: STPagination {
        get {
            return associated(to: self, key: &Keys.pagination) { STPagination() }
        }
        set {
            associate(to: self, key: &Keys.pagination, value: newValue)
        }
    }
}

class STPagination {

    /**
     * Which is the current set of data displayed. Multiply this by the number of items per page and you get the total number of results
     * on screen.
     */
    var dataRound: Int = 0
    
    /**
     * Tells if the view controller is currently performing some networking operations (retrieving data from Firebase).
     */
    var isBusy: Bool = false
    
    /**
     * How many items should be returned in one query.
     */
    var itemsPerPage: Int = 20
    
    /**
     * Tells if there is still data to be retrieved.
     */
    var stillHasToGetData: Bool = true
    
    /**
     *  Mandatory to be able to detect the next set of objects.
     */
    var pivot = STPair()
}


extension UIScrollView {
    /**
     * Tells if the user reached the bottom of the scroll view.
     */
//    var scrolledToBottom: Bool {
//        let scrollViewHeight = frame.size.height
//        let scrollContentSizeHeight = contentSize.height
//        let scrollOffset = contentOffset.y
//
//        return scrollOffset + scrollViewHeight >= scrollContentSizeHeight
//    }
    var scrolledToBottom: Bool {
        get {
            let buffer = bounds.height - contentInset.top - contentInset.bottom
            let maxVisibleY = contentOffset.y + bounds.size.height
            let actualMaxY = contentSize.height + contentInset.bottom
            
            if maxVisibleY + buffer >= actualMaxY {
                return true
            }
            return false
        }
    }
}
