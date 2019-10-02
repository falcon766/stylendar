//
//  STError+Bridge.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

/**
 *  Helper funcs.
 */
extension Error {
    /**
     *  Bridges to NSError.
     */
    var code: Int {
        get {
            return (self as? STError) != nil ? (self as! STError).code : 0
        }
    }
    var bridgedCode: Int {
        get {
            return (self as NSError).code
        }
    }
    var description: String {
        get {
            return (self as NSError).description
        }
    }
    var domain: String {
        get {
            return (self as NSError).domain
        }
    }
    var userInfo: [String:AnyObject] {
        get {
            return (self as NSError).userInfo
        }
    }
}
