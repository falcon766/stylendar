//
//  STOnboardingNavigationBarController.swift
//  Stylendar
//
//  Created by Paul Berg on 23/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STOnboardingViewController {
    /**
     *  Appends the configured navigation bar to the view controller.
     */
    func appendNavigationBar() {
        navigationController?.navigationBar.setBackgroundInvisible()
        navigationController?.navigationBar.hideBottomHairline()
    }
}
