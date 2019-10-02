//
//  STUser+Parser.swift
//  Stylendar
//
//  Created by Paul Berg on 27/02/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import SwiftyUserDefaults
import SwiftyJSON

extension STUser {
    
    /**
     *  Simply updates the user with the latest version of the singleton.
     */
    func update() {
        /**
         *  Because this function is called in the `didEnterBackground` method of the apps' delegate, it can happen to run into a racing
         *  issue and trying to update a nil object. We make sure that won't happen here.
         */
        STDatabase.shared.updateUser()
    }
    
    
    /**
     *  Simply updates the user's essentials with the latest version of the singleton.
     */
    func updateEssentials() {
        /**
         *  Because this function is called in the `didEnterBackground` method of the apps' delegate, it can happen to run into a racing
         *  issue and trying to update a nil object. We make sure that won't happen here.
         */
        STDatabase.shared.updateUserEssentials()
    }

}


extension STUser {
    /**
     *  Converts a given dictionary into an `STUser` instance.
     */
    func parse(_ dictionary: [String:AnyObject]) {
        defer {
            STDatabase.shared.state = .still
        }
        guard let selfUid = Auth.auth().currentUser?.uid else { return }
        uid = selfUid
        email = dictionary["email"] as? String
        username = dictionary["username"] as? String
        profileImageUrl = dictionary["profileImageUrl"] as? String
        createdAt = dictionary["createdAt"] as? String
        
        /**
         *  We try to obtain the name dictionary.
         */
        if let nameDictionary = dictionary["name"] as? [String:AnyObject] {
            name.full = nameDictionary["full"] as? String
            name.first = nameDictionary["first"] as? String
            name.last = nameDictionary["last"] as? String
        }
        
        if let notificationsDictionary = dictionary["notifications"] as? [String:AnyObject] {
            notifications.enabled = notificationsDictionary["enabled"] as? Bool
        } else {
            notifications.enabled = true
        }
        
        if let privacyDictionary = dictionary["privacy"] as? [String:AnyObject] {
            privacy.isStylendarPublic = privacyDictionary["isStylendarPublic"] as? Bool
        } else {
            privacy.isStylendarPublic = true
        }
        
        cache()
    }
}
