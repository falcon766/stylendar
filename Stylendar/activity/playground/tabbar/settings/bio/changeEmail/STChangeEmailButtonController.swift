//
//  STChangeEmailButtonController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangeEmailViewController {
    /**
        Called when the 'Save' button (top-right) was tapped.
     */
    @IBAction func didTapSaveButton(_ sender: Any) {
        view.endEditing(true)
        
        /**
            If there's nothing to be saved, we alert the user.
         */
        if emailTextField.text! == STUser.shared.email {
            STAlert.top(NSLocalizedString("You can't save the same email", comment: ""), isPositive: false)
            return
        }
        
        /**
            We proceed to change the password only if all the requirements are met.
         */
        if !isDataValid() {
            return
        }
        
        changeEmail()
    }

}
