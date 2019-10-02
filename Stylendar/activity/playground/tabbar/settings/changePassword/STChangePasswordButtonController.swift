//
//  STChangePasswordButtonController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangePasswordViewController {
    /**
        Called when the 'Save' button (top-right) was tapped.
     */
    @IBAction func didTapSaveButton(_ sender: Any) {
        view.endEditing(true)
        
        /**
         *  If there's nothing to be saved, we alert the user.
         */
        if currentPasswordTextField.text!.characters.count == 0 &&
            newPasswordTextField.text!.characters.count == 0 &&
            confirmNewPasswordTextField.text!.characters.count == 0 {
            STAlert.top(NSLocalizedString("All fields are empty", comment: ""), isPositive: false)
            return
        }
        
        /**
            Otherwise, we verify and append the change.
         */
        /**
            We proceed to change the password only if all the requirements are met.
         */
        if !isDataValid() {
            return
        }
        
        reauthenticate()
    }
}
