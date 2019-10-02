//
//  STChangeEmailData.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangeEmailViewController {
    
    /**
     Checks to see if the entered password data is valid.
     */
    func isDataValid() -> Bool {
        /**
            Email requirements.
         */
        if !emailTextField.text!.isEmail() {
            STAlert.top(NSLocalizedString("This email format appears to be invalid", comment: ""), isPositive: false)
            return false
        }
        
        /**
            Password requirements.
         */
        // We do not allow less than 8 characters and more than 100.
        if passwordTextField.text!.characters.count < 8 || passwordTextField.text!.characters.count > 100 {
            STAlert.top(NSLocalizedString("Password must have between 8 and 100 characters", comment: ""), isPositive: false)
            return false
        }
        
        return true
    }
}
