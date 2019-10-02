//
//  STPeopleData+Startup.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 01/09/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STPeopleViewController {
    /**
     *  Initializes the data on the page.
     */
    func startup() {
        /**
         *  Kickstars the pagination by setting the initial desired items per page values.
         */
        for pagination in paginations {
            pagination.itemsPerPage = 20
        }

        /**
         *  Makes sure the initial segmented control index is correct, because the state can be changed from outside of the view controller.
         */
        segmentedControl.selectedSegmentIndex = state.rawValue
    }
}
