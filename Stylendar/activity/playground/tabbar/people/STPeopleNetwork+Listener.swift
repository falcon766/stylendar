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
        let ref = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.requests.node)
            .child(authId)
        
        /**
         *  Firebase mantains a continuous connection with their servers, so everytime the follow requests count will be updated, we will know.
         */
        ref.observe(.value, with: { [weak self] (snapshot: DataSnapshot) in
            guard let strongSelf = self, snapshot.exists() else { return }
            strongSelf.updateFollowRequestsBadge(Int(snapshot.childrenCount))
        })
    }
}
