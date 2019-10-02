//
//  STObject.swift
//  Stylendar
//
//  Created by Paul Berg on 12/04/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
var isSelectedHandler: UInt8 = 0

extension NSObject {
    
    /**
        Convenience property to allow accessing an `isSelected` for any NSObject in the project. Useful for selection pages, where the user must choose between multiple items.
     */
    var isSelected: Bool {
        get {
            return objc_getAssociatedObject(self, &isSelectedHandler) as! Bool
        }
        set {
            objc_setAssociatedObject(self, &isSelectedHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
