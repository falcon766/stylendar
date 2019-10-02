//
//  STForgotPasswordData.swift
//  Stylendar
//
//  Created by Paul Berg on 25/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STForgotPasswordViewController {
    /**
        Checks to see if the entered profile data is valid.
     */
    func isDataValid() -> Bool {
        /**
            Email requirements.
         */
        if !self.emailTextField.text!.isEmail() {
            STAlert.top(NSLocalizedString("Invalid email address", comment: ""), isPositive: false)
            return false
        }
        
        return true
    }
}
