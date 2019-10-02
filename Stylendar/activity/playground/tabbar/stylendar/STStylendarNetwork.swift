//
//  STStylendarNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 31/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

extension STStylendarViewController {
    /**
     *  Retrieve the stylendar.
     */
    func retrieveStylendar() {
        guard state == .personal, let authId = Auth.auth().currentUser?.uid else {
            retrieveStylendarFailure(STError.networkError)
            return
        }
        
        let stylendarRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.stylendar.node)
            .child(authId)
        let promise = PromiseKit.wrap{stylendarRef.observeSingleEvent(of: .value, with: $0)}
        
        firstly { () -> Promise<DataSnapshot> in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            return promise
            }.then{ (snapshot) -> Void in
            self.appendStylendar(snapshot.value)
            }.catch { (error) -> Void in
            self.retrieveStylendarFailure(error)
            }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    fileprivate func retrieveStylendarFailure(_ error: Error) {
        dismissLoadingState()
        STError.playground(error)
    }
    
    /**
     *  If this is a global stylendar, we have to retrieve the data (for the `createdAt` and the `stylendar`).
     */
    func retrieveGlobalData() {
        guard let uid = data.user.uid, let selfUid = Auth.auth().currentUser?.uid else { return }
        let profileRef = STDatabase
            .shared
            .ref
            .child(STUser.node)
            .child(uid)
        let stylendarRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.stylendar.node)
            .child(uid)
        let followingRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.following.node)
            .child(selfUid)
            .queryOrdered(byChild: STUser.uid)
            .queryEqual(toValue: uid)
            .queryLimited(toFirst: 1)
        let requestRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.requests.node)
            .child(uid)
            .queryOrdered(byChild: STUser.uid)
            .queryEqual(toValue: selfUid)
            .queryLimited(toFirst: 1)
        
        let profilePromise = PromiseKit.wrap{profileRef.observeSingleEvent(of: .value, with: $0)}
        let stylendarPromise = PromiseKit.wrap{stylendarRef.observeSingleEvent(of: .value, with: $0)}
        let followingPromise = PromiseKit.wrap{followingRef.observeSingleEvent(of: .value, with: $0)}
        let requestPromise = PromiseKit.wrap{requestRef.observeSingleEvent(of: .value, with: $0)}
        firstly {
            when(fulfilled: profilePromise, stylendarPromise, followingPromise, requestPromise)
            }.then{ (snapshots) -> Void in
                self.handle([snapshots.0, snapshots.1, snapshots.2, snapshots.3])
            }
            .catch{ (error) -> Void in
                self.retrieveGlobalDataFailure(error)
        }
    }
    
    fileprivate func retrieveGlobalDataFailure(_ error: Error) {
        dismissLoadingState()
        STError.playground(error)
    }
}
