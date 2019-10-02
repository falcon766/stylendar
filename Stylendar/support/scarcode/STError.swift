//
//  STError.swift
//  Stylendar
//
//  Created by Paul Berg on 22/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth

/**
 *  A helper class which handles some common error actions.
 */
class STError: Error {
    public var code: Int = 0
    
    public init() {
        
    }
    
    public init(code: Int) {
        self.code = code
    }
    
    /**
     *  Handles the credential errors. They are self-explanatory.
     */
    class func credential(_ error: Error) {
        print("\(#function): \(error.localizedDescription)")
        
        var message = ""
        
        /**
         *  See STErrorTests.swift for explanations.
         */
        if let stylendarError = error as? STError {
            switch stylendarError.code {
            case STError.inviteFormatCode:
                message = NSLocalizedString("First name, last name or email invalid", comment: "")
                break
            case STError.inviteSubmittedAlreadyCode:
                message = NSLocalizedString("You've already submitted a request for this email.", comment: "")
                break
            case STError.uploadImageDataCode:
                STAlert.center(title: STString.oops, message: STString.networkError)
                break
            case STError.usernameAlreadyExistsCode:
                message = NSLocalizedString("This username appears to be already in use", comment: "")
                break
            default:
                message = STString.unknownError
                break
            }
        } else {
            switch error.bridgedCode {
                /**
                 *  Login & Sign Up.
                 */
            case AuthErrorCode.invalidEmail.rawValue:
                message = NSLocalizedString("This email format appears to be invalid", comment: "")
                break
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                message = NSLocalizedString("This email appears to be already in use", comment: "")
                break
            case AuthErrorCode.wrongPassword.rawValue:
                message = NSLocalizedString("Incorrect password", comment: "")
                break
            case AuthErrorCode.weakPassword.rawValue:
                message = NSLocalizedString("Password is not strong enough", comment: "")
                break
                /**
                 *  Forgot Password.
                 */
            case AuthErrorCode.userNotFound.rawValue:
                message = NSLocalizedString("This email doesn’t appear to exist in our system", comment: "")
                break
                /**
                 *  Network
                 */
            case AuthErrorCode.operationNotAllowed.rawValue:
                message = STString.networkError
                break
            case AuthErrorCode.networkError.rawValue:
                message = STString.networkError
                break
            default:
                message = STString.unknownError
                break
            }
        }
        
        STAlert.top(message, isPositive: false)
    }
    
    
    
    /**
     *  Handles the playground errors. They are self-explanatory.
     */
    class func playground(_ error: Error) {
        print("\(#function): \(error.localizedDescription)")
        
        var message = ""
        
        /**
         *  See STErrorTests.swift for explanations.
         */
        if let stylendarError = error as? STError {
            switch stylendarError.code {
            case STError.networkErrorCode:
                message = STString.networkError
                break
            case STError.memoryErrorCode:
                STAlert.center(title: STString.oops, message: NSLocalizedString("You're running low on memory. Try to close some apps and data.", comment: ""))
                break
            case STError.uploadImageDataCode:
                STAlert.center(title: STString.oops, message: STString.networkError)
                break
            case STError.uploadImageSizeCode:
                message = STString.uploadImageSizeError
                break
            case STError.noUsersFoundCode:
                message = NSLocalizedString("Sadly, no users were found", comment: "")
                break
            case STError.reportSubmittedAlreadyCode:
                message = STString.reportSubmittedAlready
                break
            default:
                message = STString.unknownError
                break
            }
        } else {
            switch error.bridgedCode {
                /**
                 *  Network
                 */
            case AuthErrorCode.operationNotAllowed.rawValue:
                message = STString.networkError
                break
            case AuthErrorCode.networkError.rawValue:
                message = STString.networkError
                break
            default:
                message = STString.unknownError
                break
            }
        }
        
        STAlert.top(message, isPositive: false)
    }
}



