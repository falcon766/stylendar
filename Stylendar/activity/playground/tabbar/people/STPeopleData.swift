//
//  STPeopleData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension Array where Iterator.Element == [STEdge] {
    /**
     *  Sugar subscrip to retrieve the user at a specified index without writing the `rawValue` of the enum everytime.
     */
    subscript(state: STPeopleViewControllerState) -> [STEdge] {
        get {
            return self[state.rawValue]
        }
        set {
            self[state.rawValue] = newValue
        }
    }
}

extension Array where Iterator.Element == STPagination {
    /**
     *  Sugar subscrip to retrieve the pagination at a specified index without writing the `rawValue` of the enum everytime.
     */
    subscript(state: STPeopleViewControllerState) -> STPagination {
        get {
            return self[state.rawValue]
        }
        set {
            self[state.rawValue] = newValue
        }
    }
}

class STPeopleData {
    var edges: [[STEdge]] = [[STEdge](), [STEdge](), [STEdge]()]
    
    /**
     *  Tells the view controller if it should redirect the user to the freshly received notification's user's stylendar.
     */
    var userToRedirectTo: STUser!
    var shouldRedirectToStylendar = false
}
