//
//  STPeopleData+Handler.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

extension STPeopleViewController {
    /**
     *  Appends the data retrieved from Firebase.
     */
    func handle(_ snapshot: DataSnapshot) {
        print("\(#function): \(snapshot.value ?? "snapshot is nil bro")")
        
        var edges = [STEdge]()
        let length: Int = Int(snapshot.childrenCount)
        
        /**
         *  Because `snapshot.val()` is not iterable, we use `snapshot.children`.
         */
        let enumerator = snapshot.children
        while let edgeSnapshot = enumerator.nextObject() as? DataSnapshot {
            if let dictionary = edgeSnapshot.value as? [String:AnyObject] {
                let edge = STEdge(from: dictionary)
                edge.pushId = edgeSnapshot.key
                edges.append(edge)
            }
        }
        
        /**
         *  Dismiss the loading state and the refresh control view and clear the containers if the 'dataRound' is 0.
         */
        if paginations[state].dataRound == 0 {
            dismissLoadingState()
            data.edges[state].removeAll()
        }
        
        /**
         *  Set the pagination's `isBusy` to false because the work is done. We also increment the pagination's `dataRound`.
         */
        paginations[state].isBusy = false
        paginations[state].dataRound += 1
        
        /**
         *  We purposely retrieve `itemsPerPage` + 1 elements because the last element is going to be our offset for the next page query.
         *  Of course, if there aren't `itemsPerPage`+ 1 elements, it means there aren't that many posts in the database, so we set
         *  `stillHasToGetData` on `false`.
         */
        if length == paginations[state].itemsPerPage + 1 {
            let index = length - 1
            if state != .following {
                paginations[state].pivot.key = edges[index].pushId
                paginations[state].pivot.value = edges[index].user.uid
            } else {
                paginations[state].pivot.value = edges[index].pushId
            }
            edges.remove(at: index)
        } else {
            paginations[state].stillHasToGetData = false
        }
        
        /**
         *  Merge the two arrays and update the UI.
         */
        data.edges[state] = edges
        tableView.reloadDataWithCompletion(completion: { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.data.shouldRedirectToStylendar {
                strongSelf.data.shouldRedirectToStylendar = false
                STIntent.gotoStylendar(sender: strongSelf, user: strongSelf.data.userToRedirectTo)
            }
        })
    }
    
    /**
     *  Reloads the list view after some action which requires this to occur. Example: refresh control view.
     */
    func reload() {
        /**
         * Clears the containers and the state.
         */
        paginations[state].dataRound = 0
        paginations[state].isBusy = false
        paginations[state].pivot = STPair()
        paginations[state].stillHasToGetData = true
        
        /**
         * Retrieving the data again.
         */
        retrieveUsers()
    }
}
