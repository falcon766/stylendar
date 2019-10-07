//
//  STLoginNetwork.swift
//  Stylendar
//
//  Created by Paul Berg on 16/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STLoginViewController {
    
    /**
     *  Simply logins the user using the classic email & password.
     */
    func login() {
        if !STDevice.isOnline {
            STAlert.top(STString.internetError, isPositive: false)
            return
        }
        
        appendLoadingState()
        Auth.auth().signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!,
                               completion: { [weak self] (user, error) in
                                guard let strongSelf = self else { return }
                                strongSelf.handleResponse(error: error)
        })
    }
    
    /**
     *  Handles the response of the request made above. We're  going to the playground.
     */
    fileprivate func handleResponse(error: Error?) {
        dismissLoadingState()
        if error != nil {
            STError.credential(error!)
            return
        }
        
        /**
         *  The user is not successfully logged in until the email is verified.
         */
        if Auth.auth().currentUser?.isEmailVerified == false {
            STIntent.gotoEmailVerification(sender: self)
            return
        }
        STIntent.gotoPlaygroundAsRoot()
    }
}
