//
//  STPostSingleData.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 31/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STPostSingleData {
    var user: STUser!
    var postImageUrl: String?
    var date: String?
    
    init() {
        
    }
    
    init(user: STUser, postImageUrl: String?, date: String?) {
        self.user = user
        self.postImageUrl = postImageUrl
        self.date = date
    }
}
