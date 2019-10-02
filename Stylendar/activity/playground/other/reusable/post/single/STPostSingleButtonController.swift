//
//  STPostSingleButtonController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 14/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STPostSingleViewController {
    
    /**
     *  Called when the profile area was tapped.
     */
    @IBAction func didTapProfileArea(_ sender: Any) {
        STIntent.gotoStylendar(sender: self, user: data.user)
    }
}

