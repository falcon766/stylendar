//
//  STLoginData.swift
//  Stylendar
//
//  Created by Paul Berg on 16/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STLoginData {
    var dummy: String?
}

extension STLoginViewController {
    /**
     *  Checks to see if the entered profile data is valid.
     */
    func isDataValid() -> Bool {
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
        // We do not allow less than 6 characters and more than 100.
        if passwordTextField.text!.characters.count < 6 || passwordTextField.text!.characters.count > 100 {
            STAlert.top(NSLocalizedString("Password must have between 6 and 100 letters", comment: ""), isPositive: false)
            return false
        }
        
        // We do not allow spaces at the beginning and at the end of the string.
        if passwordTextField.text![0] == " " || passwordTextField.text![passwordTextField.text!.characters.count-1] == " " {
            STAlert.top(NSLocalizedString("Password's first and last char cannot be a space", comment: ""), isPositive: false)
            return false
        }
        
        return true
    }
}
