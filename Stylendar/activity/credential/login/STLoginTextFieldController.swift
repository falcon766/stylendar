//
//  STLoginTextFieldController.swift
//  Stylendar
//
//  Created by Paul Berg on 22/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STLoginViewController: UITextFieldDelegate {
    
    /**
     *  The text field delegate.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        
        if textField == passwordTextField {
            didTapSignInButton(textField)
        }
        return true
    }
    
    /**
     *  Called when the background was tapped.
     */
    @IBAction func didTapBackground(_ sender: Any) {
        view.endEditing(true)
    }
}
