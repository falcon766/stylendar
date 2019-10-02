//
//  STSearchScrollViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 21/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STSearchViewController {
    /**
     *  The plain, simple scroll view delegate.
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /**
         * We trigger other data retrieval only if all the conditions are met:
         *
         * - The view controller is not busy, which means is not currently performing a Firebase operation: `state != .buffering`
         * - There is still data to be retrieved: `pagination.stillHasToGetData`
         * - This is not the initial point of the page (the data was retrieved at least once): `pagination.dataRound > 0`
         */
        if scrollView.scrolledToBottom && state != .buffering && pagination.stillHasToGetData && pagination.dataRound > 0 {
            retrieveUsers()
        }
    }
}
