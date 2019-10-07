
//
//  STStylendarButtonController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STStylendarViewController {
    
    /**
     *  Called when the camera button (second tab in the tab bar) was tapped. Bridged from STPlaygroundTabBarController.swift
     *
     *  Observation: specific to state = .personal
     */
    func didTapCameraButton() {
        let date = Date()
        let path = STDate.format(date.year, date.month, date.day)
        
        guard case nil = data.urls[path] else {
            let message = NSLocalizedString("This button sets a new today post, but you already have one in the Stylendar. Try removing it before adding a new one by long-pressing the view.", comment: "")
            STAlert.center(title: STString.oops, message: message)
            return
        }
        
        // All right, let's deduct the table view and the collection view index paths from only the data we have here...
        guard let indexPaths = data.selector.indexPathsForToday() else {
            STAlert.center(title: STString.oops, message: STString.unknownError)
            return
        }
        data.selector.tableIndexPath = indexPaths[0]
        data.selector.collectionIndexPath = indexPaths[1]
        data.selector.path = path
        presentPickerAlertController(delegate: self, allowsEditing: false)
    }

    func didTapLogoButton() {
        let date = Date()
        let path = STDate.format(date.year, date.month, date.day)

        if case nil = data.urls[path]{
            appendAutoScroll()
        }
    }
}
