//
//  STForgotPasswordButtonController.swift
//  Stylendar
//
//  Created by Paul Berg on 25/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STForgotPasswordViewController {
    /**
        Called when the 'Next' button was tapped.
     */
    @IBAction func didTapNextButton(_ sender: Any) {
        view.endEditing(true)
        
        /**
            We proceed only if all the requirements are met.
         */
        if !isDataValid() {
            return
        }
        sendRequest()
    }
}
