//
//  STEmailVerificationData.swift
//  Stylendar
//
//  Created by Paul Berg on 23/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STEmailVerificationViewController {
    
    /**
     *  Check to see if the user has verified the email.
     */
    @objc func checkEmailVerificationState() {
        /**
         *  Very important. If this is the `editProfile` environment, we simply stop here and pop the view controller.
         */
        if state == .editProfile {
            let _ = navigationController?.popViewController(animated: true)
            return
        }
        
        /**
         *  We have to reload the current user in order to update the data from Firebase.
         */
        Auth.auth().currentUser?.reload(completion: { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            if Auth.auth().currentUser?.isEmailVerified == false {
                return
            }
            
            /**
             *  Great! We go the playground of the app.
             */
            STIntent.gotoPlaygroundAsRoot()
        })
    }
}
