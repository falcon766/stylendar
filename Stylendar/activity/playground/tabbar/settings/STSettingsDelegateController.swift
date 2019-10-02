//
//  STSettingsDelegateController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STSettingsViewController: STViewControllerDelegate {
    
    func didUpdateProfileImage() {
        updateProfileImageBarButtonItem()
    }
    
    func didUpdateName() {
        updateNameBarButtonItem()
    }
}

