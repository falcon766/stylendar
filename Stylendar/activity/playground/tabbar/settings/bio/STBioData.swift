//
//  STBioData.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit
import FirebaseAuth
import PromiseKit

class STBioData {
    var wasImageChanged = false
}

extension STBioViewController {
    /**
     *  Tells if the data entered is valid.
     */
    func isDataValid() -> Bool {
        /**
         *  Profile image requirements.
         */
        if profileImageView.image == nil {
            STAlert.top(NSLocalizedString("Profile image is mandatory", comment: ""), isPositive: false)
            return false
        }
        
        /**
         *  Username requirements.
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
        
        return true
    }
}
