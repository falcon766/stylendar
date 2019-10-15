//
//  STPeopleNetwork+Listener.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 19/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

extension STPeopleViewController {
    /**
     *  Listens to the number of follow requests and updates the UI if necessary.
     */
    func monitorFollowRequests() {
        guard let authId = Auth.auth().currentUser?.uid else { return }
        let refRequests = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.requests.node)
            .child(authId)
        
        let refFollowers = STDatabase
             .shared
             .ref
             .child(STVeins.node)
             .child(STVeins.followers.node)
             .child(authId)
        
        let refFollowing = STDatabase
             .shared
             .ref
             .child(STVeins.node)
             .child(STVeins.following.node)
             .child(authId)
        
        /**
         *  Firebase mantains a continuous connection with their servers, so everytime the follow requests count will be updated, we will know.
         */
        refRequests.observe(.value, with: { [weak self] (snapshot: DataSnapshot) in
            guard let strongSelf = self else { return }
            strongSelf.updateFollowBadgeSubtitle(Int(snapshot.childrenCount),
                                                 section: STPeopleViewControllerState.requests.rawValue)
            
        })
        refFollowers.observe(.value, with: { [weak self] (snapshot: DataSnapshot) in
                guard let strongSelf = self else { return }
                strongSelf.updateFollowBadgeSubtitle(Int(snapshot.childrenCount),
                                                     section: STPeopleViewControllerState.followers.rawValue)
        })
        
        refFollowing.observe(.value, with: { [weak self] (snapshot: DataSnapshot) in
                guard let strongSelf = self else { return }
                strongSelf.updateFollowBadgeSubtitle(Int(snapshot.childrenCount),
                                                     section: STPeopleViewControllerState.following.rawValue)
        })
    }
}
