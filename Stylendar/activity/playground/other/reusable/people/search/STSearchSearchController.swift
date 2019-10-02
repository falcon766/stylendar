//
//  STSearchSearchController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Alamofire

extension STSearchViewController: UISearchResultsUpdating {
    /**
     *  The search results update delegate.
     */
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, query.isValid else {
            data.query = ""
            tableView.reloadData()
            return
        }
        /**
         *  This method is also called when the search bar becomes the first responder and we want to make sure we don't update the view when the query text is the same as the
         *  previous value.
         */
        guard data.query != query else { return }
        data.query = query

        /**
         *  We wish to cancel any ongoing request. Why? Read more in STViewController+Search.
         */
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { [weak self] (sessionDataTask, uploadData, downloadData) in
            guard let strongSelf = self else { return }
            sessionDataTask.forEach {
                $0.cancel()
            }
            
            /**
             *  We have to place the state change in this main thread wrapper because the `didSet` is activated for the `state` of this view controller, and it maintains the
             *  same thread as the one from where the data was changed (it's single threaded).
             *
             *  As a fact, KVO does the same. Read more: https://stackoverflow.com/questions/1282709/kvo-rocks-now-how-do-i-use-it-asynchronously#answer-1282820
             */
            DispatchQueue.main.sync {
                if sessionDataTask.isEmpty == false {
                    strongSelf.state = .idle
                }
            }

            /**
             *  Reloads the list view because we have to remove the last search results.
             */
            strongSelf.reload()
        }
    }
}
