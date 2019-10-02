//
//  STUser.swift
//  Stylendar
//
//  Created by Paul Berg on 19/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate
import SwiftyJSON
import SwiftyUserDefaults

/**
 *  The default data model for storing an user in the local data.
 *  This class does also smartly wrap the Firebase requests parameters system by providing well-built keys and nodes.
 *
 *  Super-ultra light but intelligent Singleton system. Used to power the app's user data part.
 */
class STUser: NSObject {
    
    private static var privateShared: STUser?
    
    /**
     *  This class is both a singleton for the self user and a wrapper for the other users in the network.
     */
    override init() {}
    
    /** 
     *  The actual singleton value of the class.
     */
    static var shared: STUser {
        get {
            guard let shared = privateShared else {
                privateShared = STUser()
                return privateShared!
            }
            return shared
        }
    }
    
    /**
     *  Manually destroying the singleton.
     */
    class func destroy() {
        privateShared?.invalidateCache()
        privateShared = nil
    }

    
    /**
     *  The instance properties.
     *
     *  Observation: be careful, the cache version of the properties is only returned when the user object represents the singleton instance, thus the owner
     *  of this device.
     */
    var uid: String!
    var email: String?
    lazy var username: String? = {
        let userJSON = JSON(parseJSON: Defaults[.user])
        guard
            self == STUser.privateShared,
            let username = userJSON[STUser.username].string, username.isValid
        else { return nil }
        
        return username
    }()
    lazy var profileImageUrl: String? = {
        let userJSON = JSON(parseJSON: Defaults[.user])
        guard let profileImageUrl = userJSON[STUser.profileImageUrl].string, profileImageUrl.isValid else {
            return nil
        }
        return profileImageUrl
    }()
    lazy var name: STName = {
        let userJSON = JSON(parseJSON: Defaults[.user])
        guard
            self == STUser.privateShared,
            let nameDictionary = userJSON[STUser.name.node].dictionaryObject
        else { return STName() }
        
        let name = STName()
        name.full = nameDictionary[STUser.name.full] as? String
        name.first = nameDictionary[STUser.name.first] as? String
        name.last = nameDictionary[STUser.name.last] as? String
        return name
    }()
    lazy var createdAt: String? = {
        let userJSON = JSON(parseJSON: Defaults[.user])
        guard
            self == STUser.privateShared,
            let createdAt = userJSON[STUser.createdAt].string, createdAt.isValid
        else { return nil }
        
        return createdAt
    }()
    var bio: String?
    var notifications = STNotifications()
    var privacy = STPrivacy()
    
    /**
     *  The class properties.
     */
    
    /**
     *  The keys used to read/ write the data to the server.
     */
    class final var node: String {
        get {
            return "users"
        }
    }
    
    /**
     *  The plain simple uid of the user.
     */
    class final var uid: String {
        get {
            return "uid"
        }
    }

    /**
     *  The plain simple email of the user.
     */
    class final var email: String {
        get {
            return "email"
        }
    }
    
    /**
     *  The plain simple username of the user.
     */
    class final var username: String {
        get {
            return "username"
        }
    }
    
    /**
     *  The plain simple profile image url of the user.
     */
    class final var profileImageUrl: String {
        get {
            return "profileImageUrl"
        }
    }
    
    /**
     *  Tells when the account was created.
     */
    class final var createdAt: String {
        get {
            return "createdAt"
        }
    }
    
    /**
     *  The simple description of the user.
     */
    class final var bio: String {
        get {
            return "bio"
        }
    }
    
    /**
     *  Very important, stores the fcm token to be able to send push notifications.
     */
    class final var fcmToken: String {
        get {
            return "fcmToken"
        }
    }
    
    /**
     *  Also very important, stores the utc offset of the device's timezone.
     */
    class final var utcOffset: String {
        get {
            return "utcOffset"
        }
    }
    
    /**
     * Helper object to refer the invite.
     */
    static let invitation: STInvitationRef = STInvitationRef()
    
    /**
     *  Helper object to refer the name.
     */
    static let name: STNameRef = STNameRef()
    
    /**
     *  Helper object to refer the notifications.
     */
    static let notifications: STNotificationsRef = STNotificationsRef()
    
    /**
     *  Helper object to refer the privacy settings.
     */
    static let privacy: STPrivacyRef = STPrivacyRef()
}

