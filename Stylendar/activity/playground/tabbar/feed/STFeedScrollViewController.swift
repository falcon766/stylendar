//
//  STFeedScrollViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 12/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STFeedViewController {
    /**
     *  The plain, simple scroll view delegate.
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /**
         * We trigger other data retrieval only if all the conditions are met:
         *
         * - The view controller is not busy, which means is not currently performing a Firebase operation: `pagination.isBusy`
         * - There is still data to be retrieved: `pagination.stillHasToGetData`
         * - This is not the initial point of the page (the data was retrieved at least once): `pagination.dataRound > 0`
         */
        if scrollView.scrolledToBottom && !pagination.isBusy && pagination.stillHasToGetData && pagination.dataRound > 0 {
            retrievePosts()
        }
    }
    
    /**
     *  Used when the user pulls to refresh.
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControlView.isRefreshing {
            reload()
        }
    }
}
