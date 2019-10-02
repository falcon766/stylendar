//
//  STString+Error.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  This simple yet smart extensions allows throwing Strings as Errors.
 */
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension STString {
    class var emailError: String {
        get {
            return NSLocalizedString("Please connect an email account to Apple’s native Mail app.", comment: "")
        }
    }
    
    class var internetError: String {
        get {
            return NSLocalizedString("Please connect to the Internet.", comment: "")
        }
    }
    
    class var formatError: String {
        get {
            return NSLocalizedString("Please fill in all the fields", comment: "")
        }
    }
    
    class var networkError: String {
        get {
            return NSLocalizedString("Sadly, networking issues occurred. Please try again.", comment: "")
        }
    }
    
    class var uploadImageSizeError: String {
        get {
            return NSLocalizedString("Please upload an image smaller than \(STStorage.maxSize / 1024 / 1024)MB", comment: "")
        }
    }
    
    class var unknownError: String {
        get {
            return NSLocalizedString("Error occurred. Please try again.", comment: "")
        }
    }
}
