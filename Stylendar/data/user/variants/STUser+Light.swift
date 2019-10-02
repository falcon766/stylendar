//
//  STUSERSSS
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

/**
 *  The light version initializers of the user object used
 */
extension STUser {
    class func light(uid: String?, name: String?, username: String?, profileImageUrl: String?) -> STUser {
        let user = STUser()
        user.uid = uid
        user.name.first = name
        user.username = username
        user.profileImageUrl = profileImageUrl
        return user
    }
    
    class func light(from dictionary: [String:AnyObject]) -> STUser {
        let user = STUser()
        user.uid = dictionary["uid"] as? String
        
        let authId = Auth.auth().currentUser?.uid
        if authId == nil || user.uid != authId {
            user.name.first = dictionary["name"] as? String
            user.username = dictionary["username"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
        } else {
            user.username = STUser.shared.username
            user.name.first = STUser.shared.name.first
            user.profileImageUrl = STUser.shared.profileImageUrl
        }
        return user
    }
    
    class func light(from dictionary: [String:AnyObject], isNameDict: Bool) -> STUser {
        let user = STUser()
        user.uid = dictionary["uid"] as? String
        
        let authId = Auth.auth().currentUser?.uid
        if authId == nil || user.uid != authId {
            user.username = dictionary["username"] as? String
            user.profileImageUrl = dictionary["profileImageUrl"] as? String
            
            /**
             *  We try to obtain the name dictionary.
             */
            if let nameDictionary = dictionary["name"] as? [String:AnyObject] {
                user.name.first = nameDictionary["first"] as? String
            }
        } else {
            user.username = STUser.shared.username
            user.name.first = STUser.shared.name.first
            user.profileImageUrl = STUser.shared.profileImageUrl
        }
        return user
    }
}
