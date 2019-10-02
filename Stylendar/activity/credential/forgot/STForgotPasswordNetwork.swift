//
//  STForgotPasswordNetwork.swift
//  Stylendar
//
//  Created by Paul Berg on 25/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STForgotPasswordViewController {
    /**
     *  Simply sends a forgot password request.
     */
    func sendRequest() {
        if !STDevice.isOnline {
            STAlert.top(STString.internetError, isPositive: false)
            return
        }
        
        appendLoadingState()
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!, completion: { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.handleResponse(error)
        })
    }
    
    /**
     *  Handles the response of the request made above. We're  going to the playground.
     */
    fileprivate func handleResponse(_ error: Error?) {
        dismissLoadingState()
        if error != nil {
            STError.credential(error!)
            return
        }
        
        let forgotPasswordSucessViewController = storyboard!.instantiateViewController(withIdentifier: STConstant.kSTForgotPasswordSuccessViewController) as! STForgotPasswordSuccessViewController
        forgotPasswordSucessViewController.data.email = emailTextField.text!
        navigationController!.show(forgotPasswordSucessViewController, sender: self)
    }
}
