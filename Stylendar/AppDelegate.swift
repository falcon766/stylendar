//
//  AppDelegate.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric
import Firebase
import IQKeyboardManager
import SAMKeychain
import SwiftyUserDefaults
import UserNotifications
import SwiftDate
let UserNotificationsUpdateCurrentDateNotification: Notification.Name
= Notification.Name(rawValue: "UserNotificationsUpdateCurrentDateNotification")
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    var reloadCurrentDateTimer: Timer?
    static let isWithinUnitTest: Bool = {
        if let testClass = NSClassFromString("XCTestCase") {
            return true
        } else {
            return false
        }
    }()
    
    static var hasPresentedInvalidServiceInfoPlistAlert = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // temporary fix, read more: https://github.com/firebase/firebase-ios-sdk/issues/315
        application.registerForRemoteNotifications()
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        };
        guard !AppDelegate.isWithinUnitTest else {
            // During unit tests, we don't want to initialize Firebase, since by default we want to able
            // to run unit tests without requiring a non-dummy GoogleService-Info.plist file
            return true
        }
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = false
        NotificationsController.configure()
        
        /**
         *  We clear the app's badge and finally register for pushes.
         */
        application.applicationIconBadgeNumber = 0
        
        /**
         *  Always register for remote notifications. We use UNUserNotificationCenter to request authorization for user-facing notifications.
         */
        NotificationsController.shared.registerForUserFacingNotificationsFor(application)
        printFCMToken()
        
        /**
         *  Fabric SDK.
         */
        Fabric.with([Crashlytics.self])
        STFabric.appendCrashliticsUserInformation()
        
        /**
         *  IQKeyboardManager.
         */
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        /**
         *  Local data.
         */
        let _ = STConstant()
        STDatabase.shared.retrieveUser()
        
        /**
         *  Here we verify whether the user is already logged in or not.
         */
        if let _ = Auth.auth().currentUser {
            /**
             *  We firsly wish to verify if the trigger of the app was a push, not the app icon tap.
             */
            if let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable:Any]{
                NotificationsController.shared.redirect(userInfo)
                return true
            }
            let storyboard = UIStoryboard(name: STConstant.kSTStoryboardPlayground, bundle: Bundle.main)
            let tabViewController = storyboard.instantiateInitialViewController()
            window?.rootViewController = tabViewController
            return true
        }
        
//        if Defaults[.didUserLogIn] == true {
            let storyboard = UIStoryboard(name: STConstant.kSTStoryboardCredential, bundle: Bundle.main)
            let onboardingViewController = storyboard.instantiateViewController(withIdentifier: STConstant.kSTOnboardingController)
            window?.rootViewController = onboardingViewController
            return true
//        }
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        /**
         *  We always want to make sure that the app's user & preferences are saved when the app enters the background.
         */
        STUser.shared.updateEssentials()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        /**
         *setup timer when the user start to use the app
         */
        setupNotificationToReloadCurrentDateAtMidNight()
    }

    /**
     * Set timer to update current day white the user using the app
     */
    func setupNotificationToReloadCurrentDateAtMidNight() {
        if reloadCurrentDateTimer == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .current
            dateFormatter.dateFormat = "YYYY-MM-dd hh-mm-ss"
            let nextDate = Calendar.current.dateComponents(in: .current, from: Date().add(components: 1.days))
            let date = dateFormatter.date(from: "\(nextDate.year!)-\(nextDate.month!)-\(nextDate.day!) 00-00-00")!
            let currentDate = Calendar.current.dateComponents(in: .current, from: Date()).date!
            reloadCurrentDateTimer = Timer.scheduledTimer(timeInterval: date.timeIntervalSince(currentDate), target: self, selector: #selector(notificationToReloadCurrentDate), userInfo: nil, repeats: false)

        }
    }
    /**
     * post notification to stylendar view controller to reload current day
     */
    @objc func notificationToReloadCurrentDate() {
        reloadCurrentDateTimer = nil
        NotificationCenter.default.post(name: UserNotificationsUpdateCurrentDateNotification, object: nil, userInfo: nil)
    }
}
