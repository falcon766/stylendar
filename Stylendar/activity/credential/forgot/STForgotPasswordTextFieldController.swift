//
//  STForgotPasswordTextFieldController.swift
//  Stylendar
//
//  Created by Paul Berg on 25/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STForgotPasswordViewController {
    /**
        Simply focusing the next text field when the user taps the 'Return' key.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            didTapNextButton(textField)
            return true
        }
        return true
    }
}
