//
//  STFabric.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 01/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Crashlytics
import FirebaseAuth

class STFabric {
    /**
     *  Sets the user information on the Crashlytics SDK so that we'll be able to see who owns the device on which the issue occurred.
     */
    class func appendCrashliticsUserInformation() {
        guard let authId = Auth.auth().currentUser?.uid else { return }
        Crashlytics.sharedInstance().setUserIdentifier(authId)
        Crashlytics.sharedInstance().setUserName(STUser.shared.name.full)
        Crashlytics.sharedInstance().setUserEmail(STUser.shared.email)
    }
}
