//
//  STChangePasswordNetwork.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STChangePasswordViewController {
    /**
        Sends the request to change the password on Firebase.
     */
    func reauthenticate() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: currentPasswordTextField.text!)
        
        /**
         *  Firebase imposes that we have to reauthenticate first before changing the password.
         */
        appendLoadingState()
        user.reauthenticate(with: credential, completion: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.update(user, error)
        })
    }
    
    /**
     *  Finally updates the password.
     */
    fileprivate func update(_ user: User, _ error: Error?) {
        if let error = error {
            dismissLoadingState()
            STError.credential(error)
            return
        }
        
        user.updatePassword(to: self.newPasswordTextField.text!, completion: { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.handle(error)
        })
    }
    
    /**
     *  Handles the response.
     */
    fileprivate func handle(_ error: Error?) {
        dismissLoadingState()
        if let error = error {
            STError.credential(error)
            return
        }
        
        /**
         *  We go back to the settings page if everything went all right.
         */
        navigationController?.popViewController(animated: true)
        STAlert.top("Successfully changed password", isPositive: true)
    }
}
