//
//  STError+Default.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 20/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import Foundation

/**
 *  The custom errors codes of Stylendar.
 */
extension STError {
    
    /**
     *  General ones.
     */
    class var networkErrorCode: Int {
        get {
            return 1001
        }
    }
    class var memoryErrorCode: Int {
        get {
            return 1002
        }
    }
    
    /**
     *  Special use cases.
     */
    class var inviteFormatCode: Int {
        get {
            return 1101
        }
    }
    
    class var inviteSubmittedAlreadyCode: Int {
        get {
            return 1102
        }
    }
    
    class var usernameAlreadyExistsCode: Int {
        get {
            return 1103
        }
    }
    
    class var uploadImageDataCode: Int {
        get {
            return 1104
        }
    }
    
    class var uploadImageSizeCode: Int {
        get {
            return 1105
        }
    }
    
    class var noUsersFoundCode: Int {
        get {
            return 1106
        }
    }
    
    class var reportSubmittedAlreadyCode: Int {
        get {
            return 1107
        }
    }
}

/**
 *  The custom errors of Stylendar. This extension abstracts away the initialization of the custom errors in Stylendar.
 */
extension STError {
    
    /**
     *  General ones.
     */
    class var networkError: STError {
        get {
            return STError(code: STError.networkErrorCode)
        }
    }
    class var memoryError: STError {
        get {
            return STError(code: STError.memoryErrorCode)
        }
    }
    
    /**
     *  Special use cases.
     */
    class var inviteFormat: STError {
        get {
            return STError(code: STError.inviteFormatCode)
        }
    }
    
    class var inviteSubmittedAlready: STError {
        get {
            return STError(code: STError.inviteSubmittedAlreadyCode)
        }
    }

    class var usernameAlreadyExists: STError {
        get {
            return STError(code: STError.usernameAlreadyExistsCode)
        }
    }

    class var uploadImageData: STError {
        get {
            return STError(code: STError.uploadImageDataCode)
        }
    }

    class var uploadImageSize: STError {
        get {
            return STError(code: STError.uploadImageSizeCode)
        }
    }
    
    class var noUsersFound: STError {
        get {
            return STError(code: STError.noUsersFoundCode)
        }
    }
    
    class var reportSubmittedAlready: STError {
        get {
            return STError(code: STError.reportSubmittedAlreadyCode)
        }
    }
}
