//
//  STForgotPasswordSuccessButtonController.swift
//  Stylendar
//
//  Created by Paul Berg on 26/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth

extension STForgotPasswordSuccessViewController {
    /**
        Called when the 'Login' (middle) button was tapped.
     */
    @IBAction func didTapLoginButton(_ sender: Any) {
        let loginViewController = navigationController!.viewControllers[1]
        navigationController!.popToViewController(loginViewController, animated: true)
    }
    
    /**
        Called when the 'Resend' (bottom) button was tapped.
     */
    @IBAction func didTapResendButton(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: data.email, completion: { (error) in
            if error == nil {
                STAlert.top(NSLocalizedString("Email sent", comment: ""), isPositive: false)
            }
        })
    }
}
