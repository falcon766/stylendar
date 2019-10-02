//
//  STUser+Notifications.swift
//  Stylendar
//
//  Created by Paul Berg on 27/02/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

class STNotifications {
    /**
     *  The instance properties.
     */
    var enabled: Bool!
}

/**
 *  A simple object which encapsulates the notifications dictionary stored in the Firebase database.
 */
class STNotificationsRef {
    var node: String {
        get {
            return "notifications"
        }
    }
    
    var enabled: String {
        get {
            return "enabled"
        }
    }
}
