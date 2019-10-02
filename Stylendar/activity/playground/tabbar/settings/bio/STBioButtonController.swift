//
//  STBioButtonController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyUserDefaults

extension STBioViewController {
    
    /**
     *  Called when the 'Save' button (top-right) was tapped.
     */
    @IBAction func didTapSaveButton(_ sender: Any) {
        view.endEditing(true)
        
        /**
         *  We proceed to change the password only if all the requirements are met.
         */
        if !isDataValid() {
            return
        }
        
        /**
         *  If there are no changes at all, we alert the user/
         */
        if usernameTextField.text! == STUser.shared.username
            && firstNameTextField.text! == STUser.shared.name.first
            && lastNameTextField.text! == STUser.shared.name.last
            && bioTextField.text! == STUser.shared.bio
            && data.wasImageChanged == false
        {
            STAlert.top(NSLocalizedString("No changes to save", comment: ""), isPositive: false)
            return
        }
        sync()
    }
}
