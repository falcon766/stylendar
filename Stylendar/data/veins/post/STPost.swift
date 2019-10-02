//
//  STPost.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 11/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftDate

class STPost {
    /**
     *  The instance properties.
     */
    /**
     *  The unique identifier of this object.
     */
    var id: String!
    
    /**
     *  The poster.
     */
    var sender = STUser()
    
    /**
     *  The post's image url.
     */
    var imageUrl: String?
    
    /**
     *  The date of the Stylendar.
     */
    var date = Date()
    
    /**
     *  When was this posted.
     */
    var createdAt: String?
    
    init(from dictionary: [String:AnyObject]) {
        sender = STUser.light(from: dictionary)
        imageUrl = dictionary["imageUrl"] as? String
        createdAt = dictionary["createdAt"] as? String

        if let dateValue = (dictionary["date"] as? String)?.date(format: STDateFormat.default.rawValue, fromRegion: Region.Local())?.absoluteDate {
            date = dateValue
        }
    }
    
    /**
     *  The class properties.
     */
    class var date: String {
        get {
            return "date"
        }
    }
}


