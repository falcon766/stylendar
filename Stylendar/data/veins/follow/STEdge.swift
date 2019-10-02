//
//  STEdge.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

class STEdge {
    
    var pushId: String!
    var user = STUser()
    
    init(from dictionary: [String:AnyObject]) {
        pushId = dictionary["pushId"] as? String
        user = STUser.light(from: dictionary)
    }
}
