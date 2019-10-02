//
//  STButton.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 31/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitleWithoutAnimation(_ title: String?) {
        UIView.setAnimationsEnabled(false)
        
        setTitle(title, for: .normal)
        
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
}
