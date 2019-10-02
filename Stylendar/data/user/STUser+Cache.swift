//
//  STUser+Cache.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

extension STUser {
    func cache() {
        let user: [String:Any] = [
            STUser.name.node:  [STUser.name.full: STUser.shared.name.full,
                                STUser.name.first: STUser.shared.name.first,
                                STUser.name.last: STUser.shared.name.last
            ],
            STUser.username: STUser.shared.username ?? "",
            STUser.profileImageUrl: STUser.shared.profileImageUrl ?? "",
            STUser.createdAt: STUser.shared.createdAt ?? ""
        ]
        
        Defaults[.user] = JSON(user).rawString(options: []) ?? ""
    }
    
    func invalidateCache() {
        Defaults[.user] = ""
    }
}
