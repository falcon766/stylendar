//
//  STString+Default.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  Some of the most common strings used throughout the app. This also helps internatiozaling the app.
 */
class STString {
    
    class var appName: String {
        get {
            return NSLocalizedString("Stylendar", comment: "")
        }
    }
    
    class var ok: String {
        get {
            return NSLocalizedString("Ok", comment: "")
        }
    }
    
    class var yes: String {
        get {
            return NSLocalizedString("Yes", comment: "")
        }
    }
    
    class var cancel: String {
        get {
            return NSLocalizedString("Cancel", comment: "")
        }
    }
    
    class var oops: String {
        get {
            return NSLocalizedString("Oops", comment: "")
        }
    }
    
    class var nice: String {
        get {
            return NSLocalizedString("Nice", comment: "")
        }
    }
    
    class var updateProfileSuccess: String {
        get {
            return NSLocalizedString("Successfully updated", comment: "")
        }
    }
    
    class var uploadImageSuccess: String {
        get {
            return NSLocalizedString("Successfully uploaded image", comment: "")
        }
    }
    
    class var removeImageSuccess: String {
        get {
            return NSLocalizedString("Successfully removed image", comment: "")
        }
    }
    
    class var reportSubmittedAlready: String {
        get {
            return NSLocalizedString("Thanks, you've already submitted a report for this user", comment: "")
        }
    }
}
