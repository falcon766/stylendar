//
//  STStylendarData+Startup.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 14/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

extension STStylendarViewController {
    /**
     *  Appends the startup data state of the stylendar.
     *
     *  Observation: there's no initial data for the global stylendar because (almost) everything has to be retrieved from the server.
     */
    func startup() {
        /**
         *  In special cases (eg:  user account deleted) the STDatabase doesn't yield any response. In that case, we dismiss the loading indicator even if the
         *  request wasn't finished, so that the user will be able to log out.
         */
        defer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.dismissLoadingState()
            })
        }
        
        if state == .global {
            triggeredStylendarRequest = true
            appendLoadingState()
            retrieveGlobalData()
            return
        }
        
        /**
         *  Because the user profile might not be retrieved from the database, we observe the changes and apply them when the process is done.
         */
        if STUser.shared.profileImageUrl == nil || STUser.shared.name.first == nil || STUser.shared.username == nil || STUser.shared.createdAt == nil {
            appendLoadingState()
            STDatabase.shared.addObserver(self, forKeyPath: #keyPath(STDatabase.state), options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
            return
        } else {
            /**
             *  Because there's a chance that this is not the first time this method is called (eg: when the app opens in the first tab, the observer controller).
             *  The user profile might not be retrieved yet, therefore the `data.name`, `data.profileImageUrl` could be nil. We always set them here if it's the case.
             */
            if data.user.name.first != STUser.shared.name.first {
                data.user.name.first = STUser.shared.name.first
                data.user.username = STUser.shared.username
                data.user.profileImageUrl = STUser.shared.profileImageUrl
                
                data.createdAt = STUser.shared.createdAt
                data.selector.createdAt = STUser.shared.createdAt
            }
            appendProfile()
        }
        
        /**
         *  We have to trigger the `retrieveStylendar` request because the stylendar has its own dedicated path now and the data isn't stored in the user's profile anymore.
         */
        if !triggeredStylendarRequest {
            triggeredStylendarRequest = true
            appendLoadingState()
            retrieveStylendar()
        }
    }
}
