//
//  STBioTextFieldController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

extension STBioViewController: UITextFieldDelegate {
    
    /**
        The text field delegate.
     */
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /**
         *  We're making this hack to allow spacing at the end of the right-aligned text fields.
         */
        if range.location == textField.text!.characters.count && string == " "{
            let oldString = textField.text!
            let newStart = oldString.index(oldString.startIndex, offsetBy: range.location)
            let newEnd = oldString.index(oldString.startIndex, offsetBy: range.location + range.length)
            let newString = oldString.replacingCharacters(in: newStart..<newEnd, with: string)
            textField.text = newString.replacingOccurrences(of: " ", with: "\u{00a0}")
            return false
        }
        
        if textField == firstNameTextField || textField == lastNameTextField {
            var allowed = true
            /**
             *  Max length: 70.
             */
            guard let text = textField.text else { return true }
            let newLength = text.utf16.count + string.utf16.count - range.length
            
            /**
             *  Do not allow more than 4 multiple repeating characters.
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            firstNameTextField.becomeFirstResponder()
        }
        
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        }
        
        if textField == lastNameTextField {
            emailTextField.becomeFirstResponder()
        }
        
        if textField == emailTextField {
            bioTextField.becomeFirstResponder()
        }
        
        if textField == bioTextField {
            didTapSaveButton(emailTextField)
        }

        return true
    }
}
