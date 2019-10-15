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

enum SBName:String {
    case Main = "Main"
    case Call = "Call"
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE            = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_7          = IS_IPHONE_6
    static let IS_IPHONE_7P         = IS_IPHONE_6P
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO_9_7      = IS_IPAD
    static let IS_IPAD_PRO_12_9     = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    static let IS_TV                = UIDevice.current.userInterfaceIdiom == .tv
    static let IS_CAR_PLAY          = UIDevice.current.userInterfaceIdiom == .carPlay
}

struct Version{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0 && Version.SYS_VERSION_FLOAT < 11.0)
}

