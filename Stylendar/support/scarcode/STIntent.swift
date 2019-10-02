//
//  STIntent.swift
//  Stylendar
//
//  Created by Paul Berg on 21/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyUserDefaults

/**
    A nice class which handles the intents inside the app. AKA the transitions and navigation between view controllers.
 */
class STIntent {
    
    /**
     *  Goes to the page where we listen for changes of the email verification state.
     */
    class func gotoEmailVerification(sender: UIViewController) {
        let storyboard = UIStoryboard(name: STConstant.kSTStoryboardCredential, bundle: Bundle.main)
        let emailVerificationViewController = storyboard.instantiateViewController(withIdentifier: STConstant.kSTEmailVerificationController) as! STEmailVerificationViewController
        
        /**
            The email verification view controller has two states, depending upon the sender class.
         */
        if sender.isKind(of: STSignUpViewController.self) {
            emailVerificationViewController.state = .signup
        } /*else if sender.isKind(of: STChangeEmailViewController.self) {
            emailVerificationViewController.state = .editProfile
        }*/
        sender.navigationController!.show(emailVerificationViewController, sender: sender)
    }
    
    /**
     *  Goes to the root view controller of the deauhenticated user.
     */
    class func gotoCredential(sender: UIViewController) {
        gotoCredential(sender: sender, completion: nil)
    }
    
    class func gotoCredential(sender: UIViewController, completion: (() -> Void)?) {
        let storyboard = UIStoryboard(name: STConstant.kSTStoryboardCredential, bundle: .main)
//        if Defaults[.didUserLogIn] == true {
            let onboardingViewController = storyboard.instantiateViewController(withIdentifier: STConstant.kSTOnboardingController)
            sender.present(onboardingViewController, animated: true, completion: completion)
            return
//        }
        
        guard let initialViewController = storyboard.instantiateInitialViewController() else { return }
        sender.present(initialViewController, animated: true, completion: completion)
    }
    
    /**
     *  Goes to the root view controller of the authenticated user.
     */
    class func gotoPlayground(sender: UIViewController) {
        gotoPlayground(sender: sender, completion: nil)
    }
    
    class func gotoPlayground(sender: UIViewController, completion: (() -> Void)?) {
        /**
         *  After the user logs in at least once, he won't see the invitation page again.
         */
        if Defaults[.didUserLogIn] == false { Defaults[.didUserLogIn] = true }
        
        /**
         *  We always try to receive the latest user's profile when we go the playground of the app.
         */
        STDatabase.shared.retrieveUser()

        let storyboard = UIStoryboard(name: STConstant.kSTStoryboardPlayground, bundle: Bundle.main)
        let tabViewController = storyboard.instantiateInitialViewController()
        sender.present(tabViewController!, animated: true, completion: completion)
    }
    
    /**
     *  Goes to the Stylendar of the given user.
     */
    class func gotoStylendar(sender: UIViewController, user: STUser) {
        let storyboard = UIStoryboard(name: STConstant.kSTStoryboardPlayground, bundle: .main)
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: STConstant.kSTStylendarController) as? UINavigationController, let stylendarViewController = navigationController.viewControllers.first as? STStylendarViewController else {
            return
        }
        stylendarViewController.state = .global
        stylendarViewController.data = STStylendarData(user: user)
        sender.navigationController?.show(stylendarViewController, sender: self)
    }
}
