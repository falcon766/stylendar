//
//  STSignUpData.swift
//  Stylendar
//
//  Created by Paul Berg on 18/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STSignUpData {
    let dummy = true
}

extension STSignUpViewController {
    /**
        Checks to see if the entered profile data is valid.
     */
    func isDataValid() -> Bool {
        /**
         *  Image requirements.
         */
        if case nil = profileImageView.image {
            STAlert.top(NSLocalizedString("Please set a profile image", comment: ""), isPositive: false)
            return false
        }
        
       /**
        *   Username requirements.
        */
        if usernameTextField.text!.characters.count < 6 || usernameTextField.text!.characters.count > 100 {
            STAlert.top(NSLocalizedString("Username must have between 6 and 100 characters", comment: ""), isPositive: false)
            return false
        }
        
        /**
         *  Name requirements.
         */
        if !firstNameTextField.text!.isValid || !lastNameTextField.text!.isValid {
            STAlert.top(NSLocalizedString("Invalid name", comment: ""), isPositive: false)
            return false
        }
        
        /**
         *  Email requirements.
         */
        if !emailTextField.text!.isEmail() {
            STAlert.top(NSLocalizedString("Email format appears to be invalid", comment: ""), isPositive: false)
            return false
        }
    
        /**
         *  Password requirements.
         */
        // We do not allow less than 8 characters and more than 100.
        if passwordTextField.text!.characters.count < 6 || passwordTextField.text!.characters.count > 100 {
            STAlert.top(NSLocalizedString("Password must have between 6 and 100 characters", comment: ""), isPositive: false)
            return false
        }
        
        // We do not allow spaces at the beginning and at the end of the string.
        if passwordTextField.text![0] == " " || passwordTextField.text![passwordTextField.text!.characters.count-1] == " " {
            STAlert.top(NSLocalizedString("Password's first and last char cannot be a space", comment: ""), isPositive: false)
            return false
        }
        
        // Passwords have to correspond.
        if passwordTextField.text! != passwordConfirmTextField.text! {
            STAlert.top(NSLocalizedString("Passwords do not match", comment: ""), isPositive: false)
            return false
        }
        return true
    }
}
