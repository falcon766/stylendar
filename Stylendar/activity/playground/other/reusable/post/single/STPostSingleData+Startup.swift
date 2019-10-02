//
//  STPostSingleData+Startup.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 22/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STPostSingleViewController {
    
    /**
     *  Appends the data state of the given profile and post.
     */
    func startup() {
        if let profileImageUrl = data.user.profileImageUrl, let url = URL(string: profileImageUrl) {
            profileImageView.fade(with: url, errorImage: #imageLiteral(resourceName: "ic_profile"), completion: { [weak self] success in
                guard let strongSelf = self else { return }
                strongSelf.profileImageView.backgroundColor = .white
                strongSelf.profileImageView.tintColor = .appGray
            })
        }
        nameLabel.text = data.user.name.first
        
        if let postImageUrl = data.postImageUrl, let url = URL(string: postImageUrl) {
            postImageView.fade(with: url)
        }
        
        /**
         *  Setting the initial date.
         */
        guard let date = data.date else { return }
        guard let americanized = STDate.americanize(date) else { return }
        dateLabel.text = americanized
    }
}

