//
//  STProfileAnimationController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 01/09/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STProfileViewController {
    
    /**
     *  Appends the color on the navigation bar (if this is the case, when the user comes from a private account).
     */
    func appendNavigationBarColor() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.navigationBar.barTintColor = .main
            }, completion: { [weak self] success in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
}
