//
//  STDevice.swift
//  Stylendar
//
//  Created by Paul Berg on 19/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import ReachabilitySwift

/**
    A helper class which helps writing less boilerplate code.
 */
class STDevice {
    
    
    /**
        Gets the preferred language of the device.
     */
    class var deviceLanguage: String {
        get {
            if NSLocale.preferredLanguages[0].hasPrefix("en") {
                return "en"
            }
            return NSLocale.preferredLanguages[0]
        }
    }
    
    
    /**
     *  The plain, simple device's width.
     */
    class var width: CGFloat {
        get {
            return UIScreen.main.bounds.size.width
        }
    }
    
    /**
     *  The plain, simple device's height.
     */
    class var height: CGFloat {
        get {
            return UIScreen.main.bounds.size.height
        }
    }

    /**
        Returns the main view of the app.
     */
    class var mainView: UIView {
        get {
            return UIApplication.shared.keyWindow!
        }
    }
}

    
extension STDevice {
    /**
     *  Tells if the device is connected to the Internet.
     */
    class var isOnline: Bool {
        get {
            let reachability = Reachability()!
            let status = reachability.currentReachabilityStatus
            return status != .notReachable
        }
    }
    
    
    /**
     *  Tells if the device is connected to the Internet via a mobile network.
     */
    class var isOnlineOnMobile: Bool {
        get {
            let reachability = Reachability()!
            try? reachability.startNotifier()
            let status = reachability.currentReachabilityStatus
            return status == .reachableViaWWAN
        }
    }
}


extension STDevice {
    /**
     *  Tells if the device has or not a camera and, if not, display an alert view.
     */
    class var hasCamera: Bool {
        get {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                STAlert.center(title: STString.oops,
                               message: NSLocalizedString("Your device doesn't have a camera", comment: ""))
                return false
            }
            
            return true
        }
    }
    /**
     *  Tells if the device has some available media type. If not, we display an alert view.
     */
    class func allowsMedia(for sourceType: UIImagePickerControllerSourceType) -> [String]? {
        return allowsMedia(for: sourceType, mandatoryMediaTypes: [String]())
    }
    
    class func allowsMedia(for sourceType: UIImagePickerControllerSourceType, mandatoryMediaTypes: [String]) -> [String]? {
        guard let mediaTypes = UIImagePickerController.availableMediaTypes(for: sourceType) else {
            STAlert.center(title: STString.oops,
                           message: NSLocalizedString("Your device doesn't have any media available", comment: ""))
            return nil
        }
        
        for type in mandatoryMediaTypes {
            if mediaTypes.contains(type) == false {
                return nil
            }
        }
        
        return mediaTypes
    }
}
