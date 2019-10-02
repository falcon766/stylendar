//
//  STInviteTextFieldController.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STInviteViewController: UITextFieldDelegate {
    
    /**
     *  Called when the "Return" button was tapped.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }
        
        if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        }
        
        if textField == emailTextField {
            didTapSubmitButton(emailTextField)
        }
        return true
    }
}
