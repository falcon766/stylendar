//
//  STInviteData.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STInviteViewController {
    /**
     *  Verifies if the input data is correct.
     */
    func isDataValid() -> Bool {
        if !firstNameTextField.text!.isValid || !lastNameTextField.text!.isValid || !emailTextField.text!.isValid {
            STAlert.top(STString.formatError, isPositive: false)
            return false
        }
        
        if !emailTextField.text!.isEmail() {
            STAlert.top(NSLocalizedString("Please fill in a valid email", comment: ""), isPositive: false)
            return false
        }
        return true
    }
    
    /**
     *  Refreshes the page by clearing the text from the fields and cancelling any first responder active.
     */
    func refreshData() {
        view.endEditing(true)
        firstNameTextField.text! = ""
        lastNameTextField.text! = ""
        emailTextField.text! = ""
    }
    
    /*
    fileprivate func textFielfCascadeRefresh(_ textField: UITextField, frameRate: CFTimeInterval) {
        if textField.text == nil || textField.text!.characters.count == 0 {
            return
        }
        
        textField.fadeTransition(for: frameRate-0.001)
        textField.text!.characters.removeLast()
        DispatchQueue.main.asyncAfter(deadline: .now() + frameRate) { [unowned self] in
            self.textFielfCascadeRefresh(textField, frameRate: frameRate)
        }
    }
    */
}
