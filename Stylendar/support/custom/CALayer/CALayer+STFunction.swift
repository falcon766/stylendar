//
//  CALayer+STFunction.swift
//  Stylendar
//
//  Created by Paul Berg on 20/04/16.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
