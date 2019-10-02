//
//  STAction.swift
//  Stylendar
//
//  Created by Paul Berg on 21/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  A class which handles common actions triggered inside the app.
 */
class STAction {
    
    /**
     *  Triggered when the user tapps a 'Terms & Conditions' button.
     */
    class func didTapTermsButton() {
        UIApplication.shared.openURL(URL(string: "https://google.com")!)
    }
}
