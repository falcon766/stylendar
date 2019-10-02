//
//  NotificationsController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 11/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseMessaging
import UserNotifications

enum NotificationsControllerAllowedNotificationType: String {
    case none = "None"
    case silent = "Silent Updates"
    case alert = "Alerts"
    case badge = "Badges"
    case sound = "Sounds"
}

let APNSTokenReceivedNotification: Notification.Name
    = Notification.Name(rawValue: "APNSTokenReceivedNotification")
let UserNotificationsChangedNotification: Notification.Name
    = Notification.Name(rawValue: "UserNotificationsChangedNotification")

class NotificationsController: NSObject {
    
    static let shared: NotificationsController = {
        let instance = NotificationsController()
        return instance
    }()
    
    class func configure() {
        let sharedController = NotificationsController.shared
        // Always become the delegate of UNUserNotificationCenter, even before we've requested user
        // permissions
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = sharedController
        }
    }
    
    func registerForUserFacingNotificationsFor(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound],
                                      completionHandler: { (granted, error) in
                                        NotificationCenter.default.post(name: UserNotificationsChangedNotification, object: nil)
                })
        } else if #available(iOS 9.0, *) {
            let userNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound],
                                                                      categories: [])
            application.registerUserNotificationSettings(userNotificationSettings)
            
        } else {
            application.registerForRemoteNotifications(matching: [.alert, .badge, .sound])
        }
    }
    
    func getAllowedNotificationTypes(_ completion:
        @escaping (_ allowedTypes: [NotificationsControllerAllowedNotificationType]) -> Void) {
        
        guard Messaging.messaging().apnsToken != nil else {
            completion([.none])
            return
        }
        
        var types: [NotificationsControllerAllowedNotificationType] = [.silent]
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                if settings.alertSetting == .enabled {
                    types.append(.alert)
                }
                if settings.badgeSetting == .enabled {
                    types.append(.badge)
                }
                if settings.soundSetting == .enabled {
                    types.append(.sound)
                }
                DispatchQueue.main.async {
                    completion(types)
                }
            })
        } else if #available(iOS 8.0, *) {
            if let userNotificationSettings = UIApplication.shared.currentUserNotificationSettings {
                if userNotificationSettings.types.contains(.alert) {
                    types.append(.alert)
                }
                if userNotificationSettings.types.contains(.badge) {
                    types.append(.badge)
                }
                if userNotificationSettings.types.contains(.sound) {
                    types.append(.sound)
                }
            }
            completion(types)
        } else {
            let enabledTypes = UIApplication.shared.enabledRemoteNotificationTypes()
            if enabledTypes.contains(.alert) {
                types.append(.alert)
            }
            if enabledTypes.contains(.badge) {
                types.append(.badge)
            }
            if enabledTypes.contains(.sound) {
                types.append(.sound)
            }
            completion(types)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
@available(iOS 10.0, *)
extension NotificationsController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        // Always show the incoming notification, even if the app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
}

// MARK: - Redirect
extension NotificationsController {
    func redirect(_ userInfo: [AnyHashable: Any]) {
        guard
            let notificationType = userInfo[STNotification.type] as? String,
            let tabBarController = UIApplication.topViewController()?.tabBarController as? STPlaygroundTabBarController
        else {
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                STIntent.gotoPlayground(sender: rootViewController, completion: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.redirect(userInfo)
                })
            }
            return
        }
        
        /**
         *  Depending upon the type, the tab bar controller will perform a different operation.
         */
        if [STNotificationType.follower.rawValue, STNotificationType.follower_request.rawValue, STNotificationType.follower_request_accepted.rawValue].contains(notificationType) {
            tabBarController.selectPeopleViewController(notificationType: STNotificationType(rawValue: notificationType)!, userInfo: userInfo)
        } else if STNotificationType.reminder.rawValue == notificationType {
            tabBarController.selectCameraViewController()
        }
    }
}
