//
//  STString.swift
//  Stylendar
//
//  Created by Paul Berg on 22/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  Helper extension for the general purposes strings.
 */
extension String {
    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }
}

/**
 *  Helper extension for the Stylendar formatting system.
 */
extension String {
    
    /**
     *  Tells if the string is valid (no 0 length, no only white spaces).
     */
    var isValid: Bool {
        get {
            if characters.count == 0 {
                return false
            }
            
            if self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" {
                return false
            }
            
            return true
        }
    }
    
    /**
     *  Fixes the goddamn non-breaking spaces issue. Read more:
     */
    func fixWhitespaces() -> String {
        return replacingOccurrences(of: "\u{00A0}", with: "\u{0020}")
    }
   
    /**
     *  Cleans all the undesired characters, such as national specific ones.
     */
    func removeSpecialCharacters() -> String {
        let cleanString = folding(options: .diacriticInsensitive, locale: .current)
        let okayCharacters : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_".characters)
        return String(cleanString.characters.filter {okayCharacters.contains($0) })
    }
}

extension String {
    /**
     *  Gets the first name from a full name.
     */
    var firstName: String {
        get {
            let parts = components(separatedBy: " ")
            if parts.count < 2 {
                return self
            }
            
            var firstName = ""
            for i in 0...parts.count-2 {
                firstName = firstName.appending(parts[i] + " ")
            }
            firstName.characters.removeLast()
            return firstName;
        }
    }
    
    /**
     *  Tells if one string is formatted as a desired Stylendar email address.
     */
    mutating func isEmail() -> Bool {
        if !isValid {
            return false
        }
        
        /**
         *  An email must have a "@" and a dot. Also, it is not allowed to have any spaces or double dots: "..".
         */
        if range(of: "@") == nil || range(of: ".") == nil || range(of: "..") != nil {
            return false
        }
        
        let parts = components(separatedBy: "@")
        
        /**
         *  Verify the local name firstly.
         */
        let local = parts[0]
        if local.characters.count > 64 {
            return false
        }

        /**
         *  Then, take a look at the domain.
         */
        let domain = parts[1]
        if domain.characters.count > 255 {
            return false
        }
        if domain.range(of: ".") == nil {
            return false
        }
        
        self = lowercased()
        return true
    }
    
    /**
     *  Tells if one string is formatted as a desired Stylendar password.
     */
    var isPassword: Bool {
        get {
            // We do not allow less than 8 characters and more than 100.
            if characters.count < 8 || characters.count > 100 {
                return false
            }
            
            // We do not allow spaces at the beginning and at the end of the string.
            if self[0] == " " || self[characters.count-1] == " " {
                return false
            }
            return true
        }
    }
}
