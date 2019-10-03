//
//  STEmailVerificationNavigationBarController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 28/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STEmailVerificationViewController {
    /**
     *  Appends the configured navigation bar to the view controller.
     *  Handles the case when the view controller is pushed frmo the login page.
     */
    func appendNavigationBar() {
        navigationController?.navigationBar.setBackgroundInvisible()
        navigationController?.navigationBar.showBottomHairline()
    }
}
