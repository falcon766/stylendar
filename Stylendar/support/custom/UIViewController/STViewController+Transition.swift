//
//  STViewController+Transition.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyUserDefaults
import SDWebImage

extension UIViewController {
    /**
     *  It's DRY code to write this function here.
     */
    func logout() {
        /**
         *  Clear the shared preferences.
         */
        Defaults.clear()
        STUser.destroy()
        
        /**
         *  Clear the cached images.
         */
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk(onCompletion: nil)
        
        /**
         *  Log out the Firebase user.
         */
        try! Auth.auth().signOut()
        
        /**
         *  Finally going back to the credentials system.
         */
        STIntent.gotoCredential(sender: self)
    }
}


extension UIViewController {
    
    /**
     *  Goes to a view controller instantiated by the storyboard names exactly like the given string. This is a navigation controller push.
     */
    func goto(viewController: UIViewController.Type) {
        goto(viewController: viewController, isNavigationController: true)
    }
    
    func goto(viewController: UIViewController.Type, isNavigationController: Bool) {
        let storyboard = UIStoryboard(name: String(describing: viewController), bundle: Bundle.main)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            print("Warning! The storyboard doesn't have any initial view controller.")
            return
        }
        if isNavigationController {
            navigationController?.show(viewController, sender: self)
        } else {
            present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
}
