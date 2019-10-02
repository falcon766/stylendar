//
//  STNotification.swift
//  Stylendar
//
//  Created by Paul Berg on 28/03/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftDate

/**
 * All the notification available on Stylendar.
 */
enum STNotificationType: String {
    case none = "none",
    follower = "follower",
    follower_request = "follower_request",
    follower_request_accepted = "follower_request_accepted",
    reminder = "reminder"
}

class STNotification {
    
    /**
     *  The instance properties.
     */
    
    /**
     *  The unique identifier of this object.
     */
    var id: String!
    
    /**
     *  When was the notification sent?
     */
    var created_time: Date!
    
    /**
     * The 'profile' image url of the model.
     */
    var image_url: String!
    
    /**
     *  The message of the notification.
     */
    var message: String!
    
    /**
     *  Tells if the notification has been seen by the user.
     */
    var seen: Bool!
    
    /**
     *  The type of the notification. Defined in STNotification+Enum.swift
     */
    var type: STNotificationType = .none
    
    
    init (dictionary: [String:AnyObject]) {
        id = dictionary["id"] as? String
        created_time = (dictionary["created_time"] as? String)?.date(format: .iso8601(options: .withInternetDateTime), fromRegion: Region.Local())!.absoluteDate
        image_url = dictionary["image_url"] as? String
        message = dictionary["message"] as? String
        seen = dictionary["seen"]!.boolValue
        type = STNotificationType(rawValue: (dictionary["notification_type"] as! String).uppercased()) ?? .none
    }
    
    

    /**
     *  The class properties.
     */
    /**
     *  The keys used to read/ write the data to the server.
     */
    class final var node: String {
        get {
            return "notifications"
        }
    }
    
    class final var type: String {
        get {
            return "type"
        }
    }
    
    class final var created_time: String {
        get {
            return "created_time"
        }
    }
    
    class final var seen: String {
        get {
            return "seen"
        }
    }
}
