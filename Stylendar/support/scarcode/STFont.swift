//
//  STFont.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 03/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension UIFont {
    
    /**
     *  Sugar method to load the beautiful Montserrat font.
     */
    class func montserrat(size: CGFloat) -> UIFont {
        guard let fontName = UIFont.fontNames(forFamilyName: "Montserrat").filter({ $0 == "Montserrat-Regular" }).first else { return UIFont.systemFont(ofSize: size)}
        let font = UIFont(name: fontName, size: size)!
        return font
    }
}
