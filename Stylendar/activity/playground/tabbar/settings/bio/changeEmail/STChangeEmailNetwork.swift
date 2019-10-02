//
//  STChangeEmailNetwork.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STChangeEmailViewController {
    /**
        Sends the request to change the email on Firebase.
     */
    func changeEmail() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: passwordTextField.text!)
        
        /**
         *  Firebase imposes that we have to reauthenticate first before changing the email.
         */
        appendLoadingState()
        user.reauthenticate(with: credential, completion: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.update(user, error)
        })
    }
    
    func update(_ user: User, _ error: Error?) {
        if let error = error {
            dismissLoadingState()
            STError.credential(error)
            return
        }
        
        user.updateEmail(to: self.emailTextField.text!, completion: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.dismissLoadingState()
            if let error = error {
                STError.credential(error)
                return
            }
            
            /**
             *  We go back to the profile page if everything went all right.
             */
            strongSelf.gotoEmailVerification()
        })
    }
    
    
    /**
        If the change email request was successful, redirects the user to the email verification page.
     */
    func gotoEmailVerification() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        /**
            We want to make sure the user didn't write a wrong email, so we send him/ her a verification email.
         */
        user.sendEmailVerification(completion: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.dismissLoadingState()
            if let _ = error {
                STAlert.top(NSLocalizedString("Couldn't change email, error occurred", comment: ""), isPositive: false)
                return
            }
            /**
                Update the Realtime database.
             */
            STUser.shared.email = strongSelf.emailTextField.text!
            STUser.shared.update()
            
            STIntent.gotoEmailVerification(sender: strongSelf)
        })
    }
}
