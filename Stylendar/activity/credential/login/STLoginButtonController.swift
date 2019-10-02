//
//  STLoginButtonController.swift
//  Stylendar
//
//  Created by Paul Berg on 21/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STLoginViewController {
    
    /**
     *  Called when the 'Sign In' (middle) button was tapped.
     */
    @IBAction func didTapSignInButton(_ sender: Any) {
        view.endEditing(true)
        
        /**
         *  We proceed to sign up the user only if all the requirements are met.
         */
        if !isDataValid() {
            return
        }
        login()
    }
    
    /**
     *  Called when the small 'Forgot Password' (towards the bottom) button was tapped.
     */
    @IBAction func didTapForgotPasswordButton(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        let storyboard = UIStoryboard(name: STConstant.kSTStoryboardForgotPassword, bundle: nil)
        let forgotPasswordViewController = storyboard.instantiateInitialViewController()!
        navigationController!.show(forgotPasswordViewController, sender: self)
    }
}
