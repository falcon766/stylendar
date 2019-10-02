//
//  STVeins.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 17/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  The name `veins` comes from a simple analogy: all the refs here represent data which is interconncted in the database. This is different from the users path, for instance,
 *  because that's static. Veins are in a continous change.
 *
 *  Observation: this is not a data holder class. It's a reference centralizer.
 */
class STVeins {
    class var node: String {
        get {
            return "veins"
        }
    }
    
    static let followers: STFollowersRef = STFollowersRef()
    static let following: STFollowingRef = STFollowingRef()
    static let requests: STRequestsRef = STRequestsRef()
    static let newsfeed: STNewsFeedRef = STNewsFeedRef()
    static let stylendar: STStylendarRef = STStylendarRef()
}
