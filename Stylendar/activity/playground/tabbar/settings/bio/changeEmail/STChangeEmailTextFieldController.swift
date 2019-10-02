//
//  STChangeEmailTextFieldController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangeEmailViewController: UITextFieldDelegate {
    /**
        The text field delegate.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            emailTextField.becomeFirstResponder()
        }
        
        if textField == emailTextField {
            didTapSaveButton(emailTextField)
        }
        
        return true
    }
}
