//
//  STPostMultipleData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 31/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftDate

class STPostMultipleData {
    var user: STUser?
    weak var selector: STSelector!
    var urls: [String:String]!
    var selected: Int!
    
    init() {
        
    }
    
    init(user: STUser, selector: STSelector, urls: [String:String], selected: Int) {
        self.user = user
        self.selector = selector
        self.urls = urls
        self.selected = selected
    }
}
