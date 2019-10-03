//
//  STColor.swift
//  Stylendar
//
//  Created by Paul Berg on 16/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  A class and an extension which simplify the process of retrieving some colors throughout the app.
 */
class STColor {
    private static var privateShared: STColor?
    var current: UIColor!
    
    static var shared: STColor {
        guard let shared = privateShared else {
            privateShared = STColor()
            return privateShared!
        }
        return shared
    }
}

extension UIColor {
    /**
     *  The most common background color used.
     */
    class var background: UIColor {
        get {
            return UIColor(red: 238/255.0, green: 240/255.0, blue: 246/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The navy blue color from the palette.
     */
    class var appBlue: UIColor {
        get {
            return UIColor(red: 0, green: 46/255.0, blue: 102/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The complementary color.
     */
    class var complementary: UIColor {
        get {
            return UIColor(red: 0, green: 0.667, blue: 0.698, alpha: 1.0) // #00aab2
        }
    }
    
    /**
     *  The most common dark blue color used throughout the app.
     */
    class var appDarkBlue: UIColor {
        get {
            return UIColor(red: 0/255.0, green: 38/255.0, blue: 99/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The most common divider color.
     */
    class var divider: UIColor {
        get {
            return UIColor(red: 86/255.0, green: 116/255.0, blue: 120/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  A nice red color to show errors.
     */
    class var error: UIColor {
        get {
            return UIColor(red: 180/255.0, green: 70/255.0, blue: 65/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The most common gray color used throughout the app.
     */
    class var appGray: UIColor {
        get {
            return .white// UIColor(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The most common green color used throughout the app.
     */
    class var appGreen: UIColor {
        get {
            return UIColor(red: 107/255.0, green: 209/255.0, blue: 107/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The most common light green color used throughout the app.
     */
    class var lightGreen: UIColor {
        get {
            return UIColor(red: 158/255.0, green: 245/255.0, blue: 167/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The most common gray color used for icons.
     */
    class var iconGray: UIColor {
        get {
            return UIColor(red: 72/255.0, green: 72/255.0, blue: 72/255.0, alpha: 1.0)
        }
    }
    
    /**
     *  The main color.
     */
    class var main: UIColor {
        get {
            return UIColor(red: 122/255.0, green: 163/255.0, blue: 176/255.0, alpha: 1.0) //  #7AA3B0
        }
    }
    
    /**
     *  The most common orange color.
     */
    class var appPink: UIColor {
        get {
            return UIColor(red: 171/255.0, green: 106/255.0, blue: 111/255.0, alpha: 1.0) //
        }
    }
}

/**
 *  Helper funcs.
 */
extension UIColor {
    
    /**
     *  Converts a hex to a UIColor.
     */
    class func parse(hex: String) -> UIColor {
        let result = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: result).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch result.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
