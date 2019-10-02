//
//  NSUserDefaultsKeys.swift
//  Stylendar
//
//  Created by Paul Berg on 12/04/16.
//  Copyright © 2016 Razvan Paul. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

private var didUserLogInKey = "didUserLogIn"
private var userRateSessionCountKey = "userRateSessionCount"

extension DefaultsKeys {
    
    /**
        The USER system.
     */
    /**
     *  The unique identifiers of the user.
     */
    static let user = DefaultsKey<String>("user")
    
    
    /**
     *  The PREFERENCE system.
     */
    static let preference = DefaultsKey<String>("preference")
    
    
    /**
     *  The app's preferences system.
     */
    static let didUserLogIn = DefaultsKey<Bool>(didUserLogInKey)
    static let userRateSessionCount = DefaultsKey<Int>(userRateSessionCountKey)
}

extension UserDefaults {
    /**
     *  Nicely clears the data on Stylendar, with respect to the important keys.
     */
    func clear() {
        /**
         *  Deleting what is not necessary, with respect to important lifetime ones.
         */
        Defaults.dictionaryRepresentation().keys.forEach {
            /**
             *  Do not delete these user defaults.
             */
            if $0 == didUserLogInKey || $0 == userRateSessionCountKey {
                return
            }
            UserDefaults.standard.removeObject(forKey: $0)
        }
        
        Defaults.synchronize()
    }
}
