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

class STUtils {
   static func formatNumber(_ n: Int) -> String {

        let num = abs(Double(n))
        let sign = (n < 0) ? "-" : ""

        switch num {

        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.truncate(places: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(n)"

        default:
            return "\(sign)\(n)"

        }
    }
}

extension Double {
    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
