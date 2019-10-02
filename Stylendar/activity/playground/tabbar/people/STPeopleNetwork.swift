//
//  STPeopleNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

extension STPeopleViewController {
    /**
     *  Depending upon the state, retrieve the user list.
     */
    func retrieveUsers() {
        /**
         *  Stop here if there's already a query going on.
         */
        guard paginations[state].isBusy == false else { return }
        guard let authId = Auth.auth().currentUser?.uid else {
            retrieveUsersFailure()
            return
        }
        appendLoadingState()
        paginations[state].isBusy = true

        /**
         *  Because the query, which is of type DatabaseReference, cannot be constructed (once is initialized, it keeps it's sorting and filtering
         *  chosen options), we are forced to write a lil bit of WET code, only the following reference being the same.
         */
        let ref: DatabaseReference = STDatabase
            .shared
            .ref
            .child(STVeins.node)
        var query: DatabaseQuery!
        
        /*
         *  Based upon the state, we retrieve data from different paths.
         */
        switch state {
        case .followers:
            query = ref
                .child(STVeins.followers.node)
                .child(authId)
            break
        case .following:
            query = ref
                .child(STVeins.following.node)
                .child(authId)
            break
        case .requests:
            query = ref
                .child(STVeins.requests.node)
                .child(authId)
            break
        }
        
        /**
         *  Also, we're preparing the callbacks before. They are the same.
         */
        let snapshotClosure: (DataSnapshot) -> Void = { [weak self] snapshot in
            guard let strongSelf = self else { return }
            if snapshot.exists() {
                strongSelf.handle(snapshot)
                return
            }
            strongSelf.retrieveUsersFailure()
        }
        
        let errorClosure: (Error) -> Void = { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.retrieveUsersFailure()
        }
        
        /**
         *  When this is the first query, we don't need to place a `startAt` filter as we want the first results.
         */
        if paginations[state].dataRound == 0 {
            query
                .queryLimited(toLast: UInt(paginations[state].itemsPerPage + 1))
                .observeSingleEvent(of: .value, with: snapshotClosure, withCancel: errorClosure)
        } else {
            if state != .following {
                query = query.queryEnding(atValue: paginations[state].pivot.value, childKey: paginations[state].pivot.key)
            } else {
                query = query.queryEnding(atValue: paginations[state].pivot.value)
            }
            query
                .queryLimited(toLast: UInt(paginations[state].itemsPerPage + 1))
                .observeSingleEvent(of: .value, with: snapshotClosure, withCancel: errorClosure)
        }
    }
    
    /**
     *  Called if the request above failed because of networking or unknown issues.
     */
    fileprivate func retrieveUsersFailure() {
        dismissLoadingState()
        paginations[state].isBusy = false
        paginations[state].stillHasToGetData = false
        tableView.reloadData()
        
        /**
         *  Very important! We only clear the containers if `dataRound` is 0, and that happens when the user has typed another content in the search bar,
         *  not when he is SCROLLING! (in that situation, the `dataRound is >= 1).
         */
        if paginations[state].dataRound == 0 {
            data.edges[state].removeAll()
            tableView.reloadData()
        }
    }
}
