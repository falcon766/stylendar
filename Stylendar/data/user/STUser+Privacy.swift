//
//  STUser+Privacy.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 09/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STPrivacyRef {
    var node: String {
        get {
            return "privacy"
        }
    }
    
    var isStylendarPublic: String {
        get {
            return "isStylendarPublic"
        }
    }
}

class STPrivacy {
    /**
     *  Tells whether the stylendar can be viewed by anyone or not.
     */
    var isStylendarPublic: Bool!
}
