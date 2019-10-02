//
//  STInviteButtonController.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STInviteViewController {
    
    /**
     *  Called when the "Submit" button (bottom) was tapped.
     */
    @IBAction func didTapSubmitButton(_ sender: Any) {
        view.endEditing(true)

        if isDataValid() == false {
            return
        }
        
        preinsertUser()
    }
}

