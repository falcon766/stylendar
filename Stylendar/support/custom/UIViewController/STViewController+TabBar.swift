//
//  STViewController+TabBar.swift
//  Stylendar
//
//  Created by Paul Berg on 23/04/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     *  Verifies and clears the notification tab bar item if it's the case.
     */
    func clearBadge() {
        if let value = navigationController?.tabBarItem.badgeValue {
            UIApplication.shared.applicationIconBadgeNumber -= Int(value)!
            tabBarItem.badgeValue = nil
            navigationController?.tabBarItem.badgeValue = nil
        }
    }
}
