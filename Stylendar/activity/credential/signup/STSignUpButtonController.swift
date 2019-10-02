//
//  STSignUpButtonController.swift
//  Stylendar
//
//  Created by Paul Berg on 21/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STSignUpViewController {
    
    /**
        Called when the 'Sign Up' button was tapped (middle)/
     */
    @IBAction func didTapSignUpButton(_ sender: Any) {
        view.endEditing(true)
        
        /**
            We proceed to sign up the user only if all the requirements are met.
         */
        if !isDataValid() {
            return
        }
        signUp()
    }
    
    /**
        Called when the 'Terms' button was tapped (bottom of the page).
     */
    @IBAction func didTapTermsButton(_ sender: Any) {
        view.endEditing(true)
        STAction.didTapTermsButton()
    }
}
