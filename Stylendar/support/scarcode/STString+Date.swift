//
//  STString+Date.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 12/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension String {
    
    /**
     *  Sugar method to pad left with "0" if the given int is lower than 10.
     */
    var padded: String {
        get {
            let toPad = 2 - self.characters.count
            if toPad < 1 { return self }
            return "".padding(toLength: toPad, withPad: "0", startingAt: 0) + self
        }
    }
}
