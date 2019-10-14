//
//  STProfileNavigationBarController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STProfileViewController {
    
    /**
     *  Appends the congigured navigation bar to the view controller.
     */
    func appendNavigationBar() {
        navigationController?.navigationBar.barTintColor = .main
        navigationItem.title = data.user.name.first?.uppercased()
    }
    
    /**
     *  Appends the configured navigation bar buttons to the view controller.
     */
    func appendNavigationBarButton() {
        let flagBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: displayMode.iconNameRightBar),
                                                style: .done,
                                                target: self,
                                                action: #selector(didTapFlagBarButtonItem))
        flagBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = flagBarButtonItem
    }
}
