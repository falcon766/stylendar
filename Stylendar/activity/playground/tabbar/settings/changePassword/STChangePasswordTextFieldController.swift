//
//  STChangePasswordTextFieldController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STChangePasswordViewController: UITextFieldDelegate {
    
    /**
        The text field delegate.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == currentPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        }
        
        if textField == newPasswordTextField {
            confirmNewPasswordTextField.becomeFirstResponder()
        }
        
        if textField == confirmNewPasswordTextField {
            didTapSaveButton(confirmNewPasswordTextField)
        }
        
        return true
    }
}
