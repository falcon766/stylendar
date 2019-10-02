//
//  STSearchData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STSearchData {
    var query: String!
    var users = [STUser]()

    public init() {}
}

extension STSearchViewController {
    /**
     * Appends the pagination's required settings to power this view controller.
     */
    func appendPaginationData() {
        pagination.dataRound = 0
        pagination.itemsPerPage = 20
    }
}
