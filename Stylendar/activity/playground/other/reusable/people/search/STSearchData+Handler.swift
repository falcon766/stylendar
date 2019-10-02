//
//  STSearchData+Handler.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

extension STSearchViewController {
    /**
     *  Appends the data retrieved from Firebase.
     */
    func handle(_ hits: [[String:AnyObject]]) {
        print("\(#function): \(hits.debugDescription)")
        
        guard let authId = Auth.auth().currentUser?.uid else { return }
        var users = [STUser](), length: Int = 0
        
        /**
         *  Because `snapshot.val()` is not iterable, we use `snapshot.children`.
         */
        for userHit in hits {
            /**
             *  We don't want the user to see his own profile here, but we wish to count the entry as a valid item for the pagination system, so that we won't have a missing
             *  element which will stop the data retrieval.
             */
            guard let _id = userHit["_id"] as? String else { continue }
            if authId == _id {
                continue
            }
            if let dictionary = userHit["_source"] as? [String:AnyObject] {
                let user = STUser.light(from: dictionary)
                user.uid = _id
                user.name.first = user.name.first?.firstName // Elasticsearch searches by the full name
                users.append(user)
                
                /**
                 *  We count the elemenths like this so that we avoid the edge cases where `hits.count` retrieves a different values than the actual iterated users.
                 */
                length += 1
            }
        }
        
        /**
         *  Dismiss the loading state and the refresh control view and clear the containers if the 'dataRound' is 0.
         */
        if pagination.dataRound == 0 {
            dismissLoadingState()
            data.users.removeAll()
        }
        /**
         * We also set the state to `idle` and increment the pagination's `dataRound` because the current round is done.
         */
        state = .idle
        pagination.dataRound += 1
        
        /**
         *  If there aren't `itemsPerPage` elements, it means there aren't that many posts in the database, so we set  `stillHasToGetData` on `false`.
         */
        if length == pagination.itemsPerPage {
            pagination.pivot.key = users[length-1].uid
            pagination.pivot.value = users[length-1].username
        } else {
            pagination.stillHasToGetData = false
        }
        
        /**
         *  Merge the two arrays and update the UI.
         */
        data.users.append(contentsOf: users)
        tableView.reloadData()
    }
    
    /**
     *  Reloads the list view after some action which requires this to occur. Example: refresh control view.
     */
    func reload() {
        /**
         * Clears the containers and the state.
         */
        pagination.dataRound = 0
        pagination.pivot = STPair()
        pagination.stillHasToGetData = true
        
        /**
         * Retrieving the data again.
         */
        retrieveUsers()
    }
}

