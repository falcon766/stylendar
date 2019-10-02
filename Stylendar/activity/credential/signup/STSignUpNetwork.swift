//
//  STSignUpNetwork.swift
//  Stylendar
//
//  Created by Paul Berg on 18/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import CWStatusBarNotification
import Firebase
import FirebaseAuth
import PromiseKit

extension STSignUpViewController {
    
    /**
     *  Sign ups the user using the classic form.
     */
    func signUp() {
        if !STDevice.isOnline {
            STAlert.top(STString.internetError, isPositive: false)
            return
        }
        appendLoadingState()
        /**
         *  If because of many reasons, the user already exists in the database (double username), we stop here and automatically redirect the user to
         *  the playground.
         */
        let ref = STDatabase
            .shared
            .ref
            .child(STUser.node)
            .queryOrdered(byChild: STUser.username)
            .queryEqual(toValue: usernameTextField.text!)
            .queryLimited(toFirst: 1)
        
        
        /**
         *  There's a very special yet beautiful case handled here. If the user has tried to sign up but lost the internet connection immediately after passing the `createUser` function, we go forward and
         *  and register the user directly, surpassing the first steps.
         */
        if let authId = Auth.auth().currentUser?.uid {
            fallbackSignUp(authId)
            return
        }
        
        /**
         *  The promises per-say.
         */
        let usernamePromise = PromiseKit.wrap{ref.observeSingleEvent(of: .value, with: $0)}
        let authenticationPromise = PromiseKit.wrap{Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: $0)}
        
        usernamePromise.then { (snapshot) -> Promise<User> in
            /**
             *  If the snapshot is not nil, it's obvious that there is already a user with the same username registered into the database.
             */
            if snapshot.exists() {
                throw STError.usernameAlreadyExists
            }
            
            return authenticationPromise
            }.then { (user) -> Promise<Void> in
                let insertPromise = PromiseKit.wrap{STDatabase
                    .shared
                    .insertUser(authId: user.uid, username: self.usernameTextField.text!, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, email: self.emailTextField.text!, bio: self.bioTextView.text, image: self.profileImageView.image!, completion: $0)}
                return insertPromise
            }.then { _ -> Void in
                self.completion()
            }
            .catch { error in
                self.dismissLoadingState()
                STError.credential(error)
            }
    }
    
    /**
     *  Handles the response of the request made above. We're going to the email verification page.
     */
    fileprivate func completion() {
        dismissLoadingState()

        /**
         *  We're sending a verification email to the user, then we go to the idle page where he is notified that he/ she should check out his/ her email.
         */
        Auth.auth().currentUser?.sendEmailVerification()
        STIntent.gotoEmailVerification(sender: self)
    }
    
    
    /**
     *  The special case.
     */
    func fallbackSignUp(_ authId: String) {
        let insertPromise = PromiseKit.wrap{STDatabase
            .shared
            .insertUser(authId: authId, username: self.usernameTextField.text!, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, email: self.emailTextField.text!, bio: self.bioTextView.text, image: self.profileImageView.image!, completion: $0)}
        insertPromise.then { _ -> Void in
            self.completion()
            }
            .catch { error in
                self.dismissLoadingState()
                STError.credential(error)
            }
    }
}
