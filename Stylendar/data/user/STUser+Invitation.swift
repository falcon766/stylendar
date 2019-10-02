//
//  STUser+Invitation.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  A simple object which encapsulates the invites to-be-sent stored in the Firebase database.
 */
class STInvitationRef {
    
    var node: String {
        get {
            return "invitations"
        }
    }
    
    var email: String {
        get {
            return "email"
        }
    }
    
    var deliver: String {
        get {
            return "deliver"
        }
    }
    
    /**
     *  Helper object to store the name.
     */
    let name: STNameRef = STNameRef()
}
