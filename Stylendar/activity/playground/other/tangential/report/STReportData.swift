//
//  STReportData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 24/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STReportData {
    var user: STUser!
}

extension STReportViewController {
    /**
     *  Checks if the data entered is valid.
     */
    func isDataValid() -> Bool {
        return reasonTextView.text!.isValid
    }
}
