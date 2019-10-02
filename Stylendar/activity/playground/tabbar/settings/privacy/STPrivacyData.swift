//
//  STPrivacyData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 09/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STPrivacyData {
    var isStylendarPublic: Bool!
}

extension STPrivacyViewController {
    /**
     *  Appends the initial settings.
     */
    func appendData() {
        data.isStylendarPublic = STUser.shared.privacy.isStylendarPublic
        
        if data.isStylendarPublic {
            publicTableViewCell.accessoryType = .checkmark
            privateTableViewCell.accessoryType = .none
        } else {
            publicTableViewCell.accessoryType = .none
            privateTableViewCell.accessoryType = .checkmark
        }
    }
}
