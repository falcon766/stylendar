//
//  STOnboardingButtonController.swift
//  Stylendar
//
//  Created by Paul Berg on 23/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STOnboardingViewController {
    
    @IBAction func didTapLogInButton(_ sender: Any) {
        let loginViewController = storyboard!.instantiateViewController(withIdentifier: STConstant.kSTLoginController)
        navigationController?.show(loginViewController, sender: self)
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let signUpViewController = storyboard!.instantiateViewController(withIdentifier: STConstant.kSTSignUpController)
        navigationController?.show(signUpViewController, sender: self)
    }
}
