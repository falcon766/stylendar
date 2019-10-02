//
//  AppDelegate+DynamicLinks.swift
//  Stylendar
//
//  Created by Paul Berg on 24/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks()?.dynamicLink(fromCustomSchemeURL: url) {
            print("\(#function): I'm handling a custom url scheme")
            self.handleIncomingDynamicLink(dynamicLink)
            return true
        }
        // Handle the URL other ways (Facebook, Twitter etc)
        return false
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let incomingUrl = userActivity.webpageURL else {
            return false
        }

        guard let substringedIncomingUrl = substringIncomingUrl(incomingUrl) else  { return false }
        
        let linkHandled = DynamicLinks.dynamicLinks()!.handleUniversalLink(substringedIncomingUrl) { [weak self] dynamicLink, error in
            guard let strongSelf = self else { return }
            if let dynamicLink = dynamicLink, let _ = dynamicLink.url {
                strongSelf.handleIncomingDynamicLink(dynamicLink)
            }
        }
        return linkHandled
    }
}

extension AppDelegate {
    /**
     *  The Firebase Dynamic Links wishes to get exactly the same string as in the database, which is: "https://mkwr8.app.goo.gl/CTXh". However, the world is not a pinky heaven,
     *  so here are some edge cases:
     *
     *  1. Xcode 9 adds some strange "huid" parameter in the URL: "?huid=kcB1ut1D3kHeoC0ng2NmAA"
     *  2. In the future, it might be possible to append data like the uid, so that the invitation link will be usable only once. However, as of Aug 13,
     */
    fileprivate func substringIncomingUrl(_ incomingUrl: URL) -> URL? {
        let incomingUrlString = incomingUrl.absoluteString
        
        /**
         *  If there is no `?` in the string, the function returns the same word as the single element of the array, so `path[0]` is `incomingUrlString`.
         */
        let parts = incomingUrlString.components(separatedBy: "?")
        return URL(string: parts[0])
    }
    
    /**
     *  This function will always open the Credentials system (Onboarding, Log In, Sign Up, etc) because there's only one dynamic link available: the invitation link sent on email.
     */
    fileprivate func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else { return }
        print("\(#function): Your incoming link parameter is: \(url)")

        let storyboard = UIStoryboard(name: STConstant.kSTStoryboardCredential, bundle: .main)
        let onboardingViewController = storyboard.instantiateViewController(withIdentifier: STConstant.kSTOnboardingController)
        window?.rootViewController = onboardingViewController
    }
}
