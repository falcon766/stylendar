//
//  STStylendarAnimationController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STStylendarViewController {
    
    /**
     *  When the `color` property gets changed, this method is called so that we properly update the UI with a nice transition.
     */
    func animateColorChange() {
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.backgroundColor = strongSelf.color
            strongSelf.navigationController?.navigationBar.barTintColor = strongSelf.color
            }, completion: { [weak self] success in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.navigationBar.layoutIfNeeded()
        })
    }
}
