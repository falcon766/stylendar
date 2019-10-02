//
//  STSettingsNavigationBarController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STSettingsViewController {
    /**
     *  Appends the configured navigat ion bar to the view controller.
     */
    func appendNavigationBarButton() {
        appendProfileAreaBarButtonItem()
        // TODO: appendTopRightTitleBarButtonItem(NSLocalizedString("SETTINGS", comment: ""))
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
}
