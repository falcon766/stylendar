//
//  STFloat.swift
//  Stylendar
//
//  Created by Paul Berg on 04/04/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension Float {
    /**
        Returns a nicely formatted float number containing only maximum 2 decimal points, but returns the int value if the decimal points are 0.
     */
    var twoDecimals: String {
        get {
            /**
                When the float is formatted like `390.000050121`, we don't care of anything after the first two decimals, so we wish to remove them.
                This is an extra edge case, and the remained would've been 3.05176e-05 (a large 'e' number) if we won't cut the rest of the float number (after the 2 decimals points).
             */
            let twoDecimalsFloat = Float(String(format: "%.2f", self))!
            
            /**
                Then, we see if the remainder of the float number divided by 1 is not 0 and we return an integer or a float depending on that result
             .
             */
            return twoDecimalsFloat.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", (self * 100).rounded() / 100)
        }
    }
}
