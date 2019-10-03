//
//  STPostMultipleData+Startup.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 22/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate

extension STPostMultipleViewController {
    /**
     *  Appends the data state of the given profile and post.
     */
    func startup() {
        view.backgroundColor = .main
        
        if let profileImageUrl = data.user?.profileImageUrl, let url = URL(string: profileImageUrl) {
            profileView.profileImageView.fade(with: url, errorImage: #imageLiteral(resourceName: "ic_profile"), completion: { [weak self] success in
                guard let strongSelf = self else { return }
                strongSelf.profileView.profileImageView.backgroundColor = .white
                strongSelf.profileView.profileImageView.tintColor = .appGray
            })
        }
        profileView.nameLabel.text = data.user?.name.first
        
        /**
         *  Set the initial date.
         */
        guard let path = data.selector.holder.paths[data.selected] else { return }
        guard let date = path.date(format: STDateFormat.default.rawValue) else { return }
        profileView.dateLabel.text = date.string(format: STDateFormat.american.rawValue)
    }
}
