//
//  STSignUpTextFieldController.swift
//  Stylendar
//
//  Created by Paul Berg on 22/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import ZSWSuffixTextView

extension STSignUpViewController: UITextFieldDelegate {
    
    /**
     *  The text field delegate.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == firstNameTextField || textField == lastNameTextField {
            var allowed = true
            /**
             *  Max length: 70.
             */
            guard let text = textField.text else { return true }
            let newLength = text.utf16.count + string.utf16.count - range.length
            
            /**
                Do not allow more than 4 multiple repeating characters.
             */
            let computed = text + string
            let len = computed.characters.count - 1
            var count = 0
            for i in (len-4..<len) where i > 0 {
                if computed[i] == computed[len] {
                    count += 1
                    if count > 2 {
                        break
                    }
                }
            }
            
            /**
             *  Only A-Z, numbers and underscores.
             */
            let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_- ").inverted
            allowed = newLength <= 70 && count < 3 && string.rangeOfCharacter(from: set) == nil
            
            
            return allowed
        }
        return true
    }
    
    /**
     *  Simply focusing the next text field when the user taps the 'Return' key.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            firstNameTextField.becomeFirstResponder()
            return true
        }
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
            return true
        }
        
        if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
            return true
        }
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            return true
        }
        
        if textField == passwordTextField {
            passwordConfirmTextField.becomeFirstResponder()
            return true
        }
        
        if textField == passwordConfirmTextField {
            /**
             *  Run loop bug, a new line gets automatically inserted.
             *
             *  Read more: https://stackoverflow.com/questions/21077842/uitextview-adding-new-line-unintentionally/21078008#21078008
             */
            bioTextView.becomeFirstResponder()
            return false
        }
        
        return true
    }
}
