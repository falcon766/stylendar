//
//  STImage+Default.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 02/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STImage {
    /**
     *  Returns a simple squared logo of the app.
     */
    class var logo: UIImage {
        get {
            return UIImage(named: "logo")!
        }
    }
    
    /**
     *  What is shown when the profile image wasn't found.
     */
    class var profileImagePlaceholder: UIImage {
        get {
            return #imageLiteral(resourceName: "ic_profile")
        }
    }
}
