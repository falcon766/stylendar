//
//  STChangePasswordData.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangePasswordViewController {
    
    /**
        Checks to see if the entered password data is valid.
     */
    func isDataValid() -> Bool {
        // We do not allow less than 8 characters and more than 100.
        if newPasswordTextField.text!.characters.count < 8 || newPasswordTextField.text!.characters.count > 100 {
            STAlert.top(NSLocalizedString("Password must have between 8 and 100 characters", comment: ""), isPositive: false)
            return false
        }
        // We do not allow spaces at the beginning and at the end of the string.
        if newPasswordTextField.text![0] == " " || newPasswordTextField.text![newPasswordTextField.text!.characters.count-1] == " " {
            STAlert.top(NSLocalizedString("Password's first and last char cannot be a space", comment: ""), isPositive: false)
            return false
        }
        
        // Passwords have to correspond.
        if newPasswordTextField.text! != confirmNewPasswordTextField.text! {
            STAlert.top(NSLocalizedString("Passwords do not match", comment: ""), isPositive: false)
            return false
        }
        
        return true
    }
}
