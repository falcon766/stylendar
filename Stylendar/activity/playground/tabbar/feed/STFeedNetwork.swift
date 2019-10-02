//
//  STFeedNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 11/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

extension STFeedViewController {
    
    /**
     * Retrievs the post list from Firebase.
     */
    func retrievePosts() {
        /**
         *  Stop here if there's already a query going on.
         */
        guard pagination.isBusy == false else { return }
        guard let authId = Auth.auth().currentUser?.uid else {
            print("\(#function): authId doesn't exist.")
            retrievePostsFailure()
            return
        }
        pagination.isBusy = true

        /**
         *  Because the query, which is of type DatabaseReference, cannot be constructed (once is initialized, it keeps it's sorting and filtering
         *  chosen options), we are forced to write a lil bit of WET code, only the following reference being the same.
         */
        let ref: DatabaseReference =
            STDatabase
                .shared
                .ref
                .child(STVeins.node)
                .child(STVeins.newsfeed.node)
                .child(authId)
        
        /**
         *  Also, we're preparing the callbacks before. They are the same.
         */
        let snapshotClosure: (DataSnapshot) -> Void = { [weak self] snapshot in
            guard let strongSelf = self else { return }
            if snapshot.exists() {
                strongSelf.handle(snapshot)
                return
            }
            print("\(#function): snapshot doesn't exist.")
            strongSelf.retrievePostsFailure()
        }
        
        let errorClosure: (Error) -> Void = { [weak self] error in
            guard let strongSelf = self else { return }
            print("\(#function): error: ", error.localizedDescription)
            strongSelf.retrievePostsFailure()
        }
        
        /**
         *  When this is the first query, we don't need to place a `startAt` filter as we want the first results.
         */
        if pagination.dataRound == 0 {
            ref.queryOrdered(byChild: STPost.date)
                .queryEnding(atValue: STDate.now(STDateFormat.default.rawValue))
                .queryLimited(toLast: UInt(pagination.itemsPerPage + 1))
                .observeSingleEvent(of: .value, with: snapshotClosure, withCancel: errorClosure)
        } else {
            ref.queryOrdered(byChild: STPost.date)
                .queryEnding(atValue: pagination.pivot.value, childKey: pagination.pivot.key)
                .queryLimited(toLast: UInt(pagination.itemsPerPage + 1))
                .observeSingleEvent(of: .value, with: snapshotClosure, withCancel: errorClosure)
        }
    }
    
    /**
     *  Called if the request above failed because of networking or unknown issues.
     */
    fileprivate func retrievePostsFailure() {
        dismissLoadingState()
        pagination.isBusy = false
        pagination.stillHasToGetData = false
        collectionView.reloadData()
        
        /**
         *  Very important! We only clear the containers if `dataRound` is 0, and that happens when the user has typed another content in the search bar,
         *  not when he is SCROLLING! (in that situation, the `dataRound is >= 1).
         */
        if pagination.dataRound == 0 {
            data.posts.removeAll()
            collectionView.reloadData()
        }
    }
}
