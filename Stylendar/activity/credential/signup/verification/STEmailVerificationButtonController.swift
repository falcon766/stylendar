//
//  STEmailVerificationButtonController.swift
//  Stylendar
//
//  Created by Paul Berg on 23/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STEmailVerificationViewController {
    /**
        Appends the configured button to the view controller.
     */
    func appendButton() {
        if state == .signup {
            centerButton.setTitle(NSLocalizedString("Check your email", comment: ""), for: .normal)
            return
        }
        
        if state == .editProfile {
            centerButton.setTitle(NSLocalizedString("Take me back", comment: ""), for: .normal)
        }
    }
}

extension STEmailVerificationViewController {
    
    /**
        Called when the 'Center' button was tapped.
     */
    @IBAction func didTapCenterButton(_ sender: Any) {
        if state == .signup {
            checkEmailVerificationState()
            return
        }
        
        if state == .editProfile {
            navigationController?.popViewController(animated: true)
        }
    }
    
    /**
     *  Called when the 'Resend' (bottom) button was tapped.
     */
    @IBAction func didTapResendButton(_ sender: Any) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if let _ = error {
                STAlert.top(STString.unknownError, isPositive: false)
                return
            }
            STAlert.top(NSLocalizedString("Successfully resent verification email", comment: ""), isPositive: true)
        })
    }

}
