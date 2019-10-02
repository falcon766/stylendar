//
//  STStylendarNavigationBarController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 29/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STStylendarViewController {
    /**
     *  Appends the congigured navigation bar to the view controller.
     */
    func appendNavigationBar() {
        navigationController?.navigationBar.barTintColor = color
    }
    
    /**
     *  Appends the follow navigation bar button item.
     */
    func appendFollowBarButtonItem(_ followButton: STFollowButton) {
        let followBarButtonItem = UIBarButtonItem(customView: followButton)
        followBarButtonItem.style = .done
        followBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = followBarButtonItem
    }
}
