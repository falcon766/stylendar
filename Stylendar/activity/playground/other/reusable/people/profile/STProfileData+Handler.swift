//
//  STProfileData+Handler.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

extension STProfileViewController {
    /**
     *  Handles the data retrieved from Firebase.
     */
    func handle(_ user: [String:AnyObject], _ followersCount: Int) {
        /**
         *  Set the data on the views.
         */
        usernameLabel.text = user["username"] as? String
        bioLabel.text = (user["bio"] as? String)?.fixWhitespaces()
        followersLabel.text = "\(followersCount)"
        
        if let nameDictionary = user["name"] as? [String:AnyObject] {
            nameLabel.text = nameDictionary["full"] as? String
        }
        
        if let profileImageUrlString = user["profileImageUrl"] as? String, let profileImageUrl = URL(string: profileImageUrlString) {
            profileImageView.fade(with: profileImageUrl, errorImage: STImage.profileImagePlaceholder, completion: { success in })
        }
    }
}
