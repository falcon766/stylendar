//
//  STPrivacyNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 09/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

extension STPrivacyViewController {
    /**
     *  When the user leaves, we update the Firebase values if the data was changed. We don't call `STUser.shared.update()` however because that would be a true
     *  overkill, we only wish to update the `privacy` path.
     *
     *  Observation: we don't update anything if the settings are the same.
     */
    @objc func update() {
        guard let authId = Auth.auth().currentUser?.uid else { return }
        guard data.isStylendarPublic != STUser.shared.privacy.isStylendarPublic else { return }

        /**
         *  Local update.
         */
        STUser.shared.privacy.isStylendarPublic = !STUser.shared.privacy.isStylendarPublic

        /**
         *  Firebase update.
         */
        let update: [String:Any] = [STUser.privacy.isStylendarPublic: data.isStylendarPublic
        ]
        let nonRetainedHandle = { (error: Error?) -> () in
            guard let error = error else {
                return
            }
            
            /**
             *  We have to re-calibrate the `isStylendarPublic` bool because an error happened and the value didn't update on Firebase.
             */
            STUser.shared.privacy.isStylendarPublic = !STUser.shared.privacy.isStylendarPublic
            STError.credential(error)
        }
        STDatabase
            .shared
            .ref
            .child(STUser.node)
            .child(authId)
            .child(STUser.privacy.node)
            .updateChildValues(update) { (error, ref) in
                nonRetainedHandle(error)
        }
    }
}
