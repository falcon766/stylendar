//
//  STPlaygroundTabBarController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import SwiftyUserDefaults
import SDWebImage

class STPlaygroundTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  Really don't know what can't they default this...
         */
        delegate = self
    }
        
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabIndex = tabBarController.viewControllers?.index(of: viewController) else { return true }
        
        /**
         *  We want a different tab bar item tint color for the feed.
         */
//        tabBar.tintColor = (tabIndex != 2 && tabIndex != 3) ? .main : .complementary

        /**
         *  Basically, the stylendar gets on screen and the image panel is opened for the user.
         */
        if tabIndex == 1, let navigationController = tabBarController.viewControllers?.first as? UINavigationController, let stylendarViewController = navigationController.viewControllers.first as? STStylendarViewController {
            selectedIndex = 0
            stylendarViewController.didTapCameraButton()
        }
 
        return tabIndex != 1
    }
}

// MARK: Notifications Helper
extension STPlaygroundTabBarController {
    
    /**
     *  When the user receives a notification of type `reminder`, this method is called to display the camera for the user.
     */
    func selectCameraViewController() {
        guard
            let navigationController = viewControllers?[0] as? UINavigationController,
            navigationController.viewControllers.count <= 1,
            let stylendarViewController = navigationController.viewControllers.first as? STStylendarViewController
        else { return }
        
        selectedIndex = 0
        stylendarViewController.didTapCameraButton()
    }
    
    /**
     *  When the user receives a notification of type `follower`, this method is called to display the follow page.
     */
    func selectPeopleViewController(notificationType: STNotificationType, userInfo: [AnyHashable:Any]) {
        guard
            let navigationController = viewControllers?[3] as? UINavigationController,
            navigationController.viewControllers.count <= 1,
            let peopleViewController = navigationController.viewControllers.first as? STPeopleViewController
        else { return }
        
        /**
         *  We finally redirect the user to the desired page. We also have to set the tint color, because the `shouldSelectViewController` method from above doesn't get called.
         */
        tabBar.tintColor = .main
        selectedIndex = 3
        
        /**
         *  We need the user's profile to redirect the app to the corresponding stylendar.
         */
        guard let userInfoDict = userInfo as? [String:AnyObject] else { return }
        let user = STUser.light(from: userInfoDict)
        peopleViewController.data.shouldRedirectToStylendar = true
        peopleViewController.data.userToRedirectTo = user
        
        switch notificationType {
        case .follower:
            peopleViewController.state = .followers
            break
        case .follower_request:
            peopleViewController.state = .requests
            break
        case .follower_request_accepted:
            peopleViewController.state = .following
            break
        default:
            peopleViewController.state = .followers
            break
        }
    }
}
