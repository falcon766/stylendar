//
//  STUtils.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 02/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

/**
 *  Sugar struct to wrap a key and a value object.
 */
struct STPair {
    var key: String?
    var value: Any?
}

/**
 *  There were several cases inside the app where we needed to divide A by B, but return B is the remainder is 0.
 */
precedencegroup NoZeroRemainder {
    associativity: left
}

infix operator %%: NoZeroRemainder

// Operator definition
public func %% (value1: Int, value2: Int) -> Int {
    return value1 % value2 != 0 ? value1 % value2 : value2
}
