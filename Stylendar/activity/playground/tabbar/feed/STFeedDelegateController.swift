//
//  STFeedDelegateController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 12/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STFeedViewController: STViewControllerDelegate {
    
    func didUpdateProfileImage() {
        updateProfileImageBarButtonItem()
    }
    
    func didUpdateName() {
        updateNameBarButtonItem()
    }
}
