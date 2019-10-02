//
//  STConstant.swift
//  Stylendar
//
//  Created by Paul Berg on 19/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class STConstant {
    
    /**
     *  App related constants.
     */
    static let kSTAppName = "Stylendar"
    
    /**
     *  Storyboard names.
     */
    static let kSTStoryboardCredential = "Credential"
    static let kSTStoryboardForgotPassword = "ForgotPassword"
    static let kSTStoryboardPlayground = "Playground"
    
    /**
     *  View controller ID's from the Storyboard.
     */
    static let kSTInviteController = "inviteController"
    static let kSTOnboardingController = "onboardingController"
    static let kSTLoginController = "loginController"
    static let kSTSignUpController = "signUpController"
    static let kSTEmailVerificationController = "emailVerificationController"
    static let kSTForgotPasswordController = "forgotPasswordController"
    static let kSTForgotPasswordSuccessViewController = "forgotPasswordSuccessController"
    
    static let kSTStylendarController = "stylendarController"
}


extension STConstant {
    
    /**
     *  The Stylendar's default email.
     */
    static let kSTDefaultEmail = "razvanbirgaoanu10@gmail.com"
    
    /**
     *  Environment keys used to communicate with the Cloud Functions.
     */
    static let kSTFirebaseCloudFunctionsKey = "TYPE_HERE"
    static let kSTFirebaseCloudFunctionOptimizer = "TYPE_HERE"
    
    /**
     *  The elastic search url and auth credentials.
     */
    static let kSTElasticSearchUrl = "http://35.202.82.149/elasticsearch/users/_search"
    static let kSTElasticSearchUsername = "user"
    static let kSTElasticSearchPassword = "v3H1GoME"
}

