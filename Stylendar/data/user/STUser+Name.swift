//
//  STUser+Name.swift
//  Stylendar
//
//  Created by Paul Berg on 27/02/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

class STName {
    /**
        The instance properties.
     */
    var full: String?
    var first: String?
    var last: String?
}

/**
 *  A simple object which encapsulates the name dictionary stored in the Firebase database.
 */
class STNameRef {
    
    var node: String {
        get {
            return "name"
        }
    }
    
    var full: String {
        get {
            return "full"
        }
    }
    
    var first: String {
        get {
            return "first"
        }
    }
    
    var last: String {
        get {
            return "last"
        }
    }
}
