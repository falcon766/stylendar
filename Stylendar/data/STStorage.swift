//
//  STStorage.swift
//  Stylendar
//
//  Created by Paul Berg on 25/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class STStorage: NSObject {
    /**
     *  Can't init, this is a singleton class.
     */
    private override init() { }
    
    /**
     *  The method which creates the Firebase database singleton.
     */
    static let shared: STStorage = STStorage()
    
    /**
     *  The main reference to the Firebase storage.
     */
    var ref: StorageReference {
        get {
            return Storage.storage().reference()
        }
    }
    
    /**
     *  Defaults paths.
     */
    var profile: String {
        get {
            return "profile"
        }
    }
    
    var stylendar: String {
        get {
            return "stylendar"
        }
    }
    
    /**
     *  Default values.
     */
    class var maxSize: Int {
        get {
            return 8 * 1024 * 1024
        }
    }
}

extension STStorage {
    /**
     *  Simple reference to the profile image ref. DRY is life.
     */
    var profileRef: StorageReference {
        get {
            guard let authId = Auth.auth().currentUser?.uid else { return ref }
            let profileImageUrl = profile + "/" + authId + STMedia.format
            return ref.child(profileImageUrl)
        }
    }
    
    /**
     *  Sugar method to generate the ref for the given day, month and year.
     */
    func stylendarRef(for day: String, month: Int, year: Int) -> StorageReference {
        return ref
            .child(STVeins.node)
            .child(STVeins.stylendar.node)
            .child(String(year))
            .child(String(month))
            .child(String(day) + STMedia.format)
    }
}


extension STStorage {
    class func mb(_ value: Int) -> Int {
        return value * 1024 * 1024
    }
}
