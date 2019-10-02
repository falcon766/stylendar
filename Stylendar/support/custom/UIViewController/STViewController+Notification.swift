//
//  STViewController+Notification.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 09/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension UIViewController {
    struct UIViewControllerKeys {
        static fileprivate var listenersActivated: UInt8 = 0
    }
    
    var listenersActivated: Bool {
        get {
            return associated(to: self, key: &UIViewControllerKeys.listenersActivated) { false }
        }
        set {
            associate(to: self, key: &UIViewControllerKeys.listenersActivated, value: newValue)
        }
    }
    
    /**
     *  This way, we have a method
     */
    func appendHomeButtonListeners(resignActive: Selector?, becomeActive: Selector?) {
        if listenersActivated == false {
            if let resignActive = resignActive {
                NotificationCenter.default.addObserver(self, selector: resignActive, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
            }
            
            if let becomeActive = becomeActive {
                NotificationCenter.default.addObserver(self, selector: becomeActive, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            }
            listenersActivated = true
        } else {
            
        }
    }
    internal func removeHomeButtonListeners() {
        NotificationCenter.default.removeObserver(self)
        listenersActivated = false
    }
}
