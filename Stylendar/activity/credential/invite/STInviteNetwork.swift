//
//  STInviteNetwork.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STInviteViewController {
    /**
     *  Sends the request to Firebase to preinsert the user.
     */
    func preinsertUser() {
        if !STDevice.isOnline {
            STAlert.top(STString.internetError, isPositive: false)
            return
        }
        
        appendLoadingState()
        // We got to replace the "." in the email because Firebase does not allow nodes with it inside.
        let email = emailTextField.text!//.replacingOccurrences(of: ".", with: ",")
        STDatabase.shared.preinsertUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: email) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.handleResponse(error: error)
        }
    }
    
    /**
     *  Handles the response of the request made above. We're finally going to the playground of the app after all the user's profile information was saved.
     */
    fileprivate func handleResponse(error: Error?) {
        dismissLoadingState()
        
        /**
         *  It may simply be a Firebase error.
         */
        if let error = error {
            STError.credential(error)
            return
        }
        
        /**
         *  If the error is nil, everything went perfect.
         */
        self.refreshData()
        STAlert.center(title: STString.nice + "!",
                       message: NSLocalizedString("You've successfully submitted the form. An invitation will be sent soon on your email.", comment: ""))
    }
}
