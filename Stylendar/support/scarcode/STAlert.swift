//
//  STAlert.swift
//  Stylendar
//
//  Created by Paul Berg on 22/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import CWStatusBarNotification

/**
 *  A helper to class to usually present alerts throughout the app.
 */

private var negative = UIColor.error
private var positive = UIColor.appGreen

class STAlert {
    
    /**
     *  Basic highlighted notification which appears in the top of the page. Uses a default value of 3.5 seconds.
     *  The default color is the `highlight` which is a kind of grena, a darker red.
     */
    
    class func top(_ message: String, isPositive: Bool) {
        top(message, color: isPositive ? positive : negative)
    }
    
    
    /**
     *  Displays a top positive notification.
     */
    class func top(_ message: String, color: UIColor) {
        let notification = CWStatusBarNotification()
        notification.notificationLabelBackgroundColor = color
        notification.notificationStyle = .navigationBarNotification
        notification.notificationAnimationInStyle = .top
        notification.notificationAnimationOutStyle = .top
        notification.display(withMessage: message, forDuration: 3.0)
    }
    
    
    /**
     *  Displays an actual alert controller in the center of the top most view controller. The default button is "Ok" and it simply
     *  dismisses the alert controller
     */
    class func center(title: String, message: String) {
        STAlert.self.center(title: title, message: message, handler: nil)
    }
    
    class func center(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: handler))
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
