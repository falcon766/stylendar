//
//  STView+Layer.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 14/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
@IBDesignable

extension UIView {
    
    @IBInspectable
    public var borderUIColor: UIColor? {
        get {
            guard let borderCgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderCgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
