//
//  STReportButtonController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 24/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STReportViewController {
    
    /**
     *  Called when the `Submit` button (bottom) was tapped.
     */
    @IBAction func didTapSubmitButton(_ sender: Any) {
        reasonTextView.resignFirstResponder()
        guard isDataValid() else {
            STAlert.top(NSLocalizedString("Plase, type your message", comment: ""), isPositive: false)
            return
        }
        submit()
    }
}
