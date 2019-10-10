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
    struct TabbarType {
        static let feed: Int = 0
        static let camera: Int = 1
        static let stylendar: Int = 2
        static let people: Int = 3
        static let setting: Int = 4

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = TabbarType.stylendar
        /**
         *  Really don't know what can't they default this...
         */
        delegate = self
        /**
         * Fix bug tabBarItem don't align vertical center on <ios 13.0
         */
        if #available(iOS 10.0, *){
            if #available(iOS 13.0, *) {} else {
                for tabBarItem in tabBar.items ?? [] {
                    tabBarItem.title = "";
                    tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
                }
            }
        } 
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
        if tabIndex == TabbarType.camera, let navigationController = tabBarController.viewControllers?[TabbarType.stylendar] as? UINavigationController, let stylendarViewController = navigationController.viewControllers.first as? STStylendarViewController {
            selectedIndex = TabbarType.stylendar
            stylendarViewController.didTapCameraButton()
        }else if tabIndex == TabbarType.stylendar, let navigationController = tabBarController.viewControllers?[TabbarType.stylendar] as? UINavigationController, let stylendarViewController = navigationController.viewControllers.first as? STStylendarViewController {
            stylendarViewController.appendAutoScroll()
        }
 
        return tabIndex != TabbarType.camera
    }
}

// MARK: Notifications Helper
extension STPlaygroundTabBarController {
    
    /**
     *  When the user receives a notification of type `reminder`, this method is called to display the camera for the user.
     */
    func selectCameraViewController() {
        guard
            let navigationController = viewControllers?[TabbarType.stylendar] as? UINavigationController,
            navigationController.viewControllers.count <= 1,
            let stylendarViewController = navigationController.viewControllers.first as? STStylendarViewController
        else { return }
        
        selectedIndex = TabbarType.stylendar
        stylendarViewController.didTapCameraButton()
    }
    
    /**
     *  When the user receives a notification of type `follower`, this method is called to display the follow page.
     */
    func selectPeopleViewController(notificationType: STNotificationType, userInfo: [AnyHashable:Any]) {
        guard
            let navigationController = viewControllers?[TabbarType.people] as? UINavigationController,
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
