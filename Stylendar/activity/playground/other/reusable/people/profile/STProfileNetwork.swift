//
//  STProfileNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

extension STProfileViewController {
    
    /**
     *  Retrievs the complete profile of the user.
     */
    func retrieve() {
        guard let uid = data.user.uid else { return }
        
        /**
         *  Create the refs and the promises.
         */
        let profileRef = STDatabase
            .shared
            .ref
            .child(STUser.node)
            .child(uid)
        let followersRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.followers.node)
            .child(uid)
        
        let profilePromise = PromiseKit.wrap{profileRef.observeSingleEvent(of: .value, with: $0)}
        let followersPromise = PromiseKit.wrap{followersRef.observeSingleEvent(of: .value, with: $0)}

        /**
         *  Kickstart the promises.
         */
        firstly {
            when(fulfilled: profilePromise, followersPromise)
            }.then { (snapshots) -> Void in
                guard
                    snapshots.0.exists(),
                    let user = snapshots.0.value as? [String:AnyObject]
                else {
                    self.failure(STError.networkError)
                    return
                }
                self.handle(user, Int(snapshots.1.childrenCount))
            }.catch { (error) in
                self.failure(error)
            }.always {
                self.dismissLoadingState()
        }
    }
    
    /**
     *  Called if the request above failed.
     */
    fileprivate func failure(_ error: Error) {
        STAlert.center(title: STString.oops, message: STString.unknownError, handler: { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        })
    }
}
