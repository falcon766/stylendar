//
//  STViewController+Navigation.swift
//  Stylendar
//
//  Created by Paul Berg on 23/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase

/**
 *  We made these ones extensions because we want the logic applied to both UIViewController and UITableViewController.
 */
extension STViewController {
    
}

extension UIViewController {
    /**
     *  Appends the top-right corner text which is usually the name of the page.
     */
    func appendTopRightTitleBarButtonItem(_ title: String) {
        guard case nil = navigationItem.rightBarButtonItem else { return }
        let barButtonItem = UIBarButtonItem(title: title.uppercased(), style: .done, target: nil, action: nil)
        barButtonItem.tintColor = .white
        barButtonItem.setTitleTextAttributes([NSAttributedStringKey(rawValue: UIFontDescriptor.AttributeName.name.rawValue): UIFont.fontNames(forFamilyName: "Montserrat")[0]], for: .normal)
        navigationItem.setRightBarButton(barButtonItem, animated: false)
    }
    
    /**
     *  Appends the profile image of the user in the top left corner.
     */
    func appendProfileAreaBarButtonItem() {
        appendProfileAreaBarButtonItem(name: STUser.shared.name.first, profileImageUrl: STUser.shared.profileImageUrl)
    }
    func appendProfileAreaBarButtonItem(name: String?, profileImageUrl profileImageUrlString: String?) {
        guard
            case nil = navigationItem.leftBarButtonItems,
            let name = name,
            let profileImageUrlString = profileImageUrlString,
            let profileImageUrl = URL(string: profileImageUrlString)
        else { return }
        
        let profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        appendFixedConstraints(profileImageView, width: 32, height: 32)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfileAreaBarButtonItem(_:)))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        /**
         *  The name bar button item.
         */
        let nameBarButtonItem = UIBarButtonItem(title: name.uppercased(), style: .done, target: self, action: #selector(didTapProfileAreaBarButtonItem(_:)))
        nameBarButtonItem.tintColor = .white
        nameBarButtonItem.setTitleTextAttributes([NSAttributedStringKey(rawValue: UIFontDescriptor.AttributeName.name.rawValue): UIFont.fontNames(forFamilyName: "Montserrat")[0]], for: .normal)
        
        /**
         *  The image bar button item.
         */
        let imageBarButtonItem = { [weak self] () -> (Void) in
            guard let strongSelf = self else { return }
            let imageBarButtonItem = UIBarButtonItem(customView: profileImageView)
            imageBarButtonItem.action = #selector(strongSelf.didTapProfileAreaBarButtonItem(_:))
            strongSelf.navigationItem.leftItemsSupplementBackButton = true
            strongSelf.navigationItem.leftBarButtonItems = [imageBarButtonItem, nameBarButtonItem]
        }
        profileImageView.fade(with: profileImageUrl, errorImage: STImage.profileImagePlaceholder, completion: { success in
            profileImageView.backgroundColor = .white
            profileImageView.tintColor = .appGray
            imageBarButtonItem()
        })
    }
    
    /**
     *  Appends the `width` and `height` constraint because starting with iOS 11 the bar button items are inside a UIStackView which applies auto layout. For lower version,
     *  there were only frames.
     */
    fileprivate func appendFixedConstraints(_ imageView: UIImageView, width: CGFloat, height: CGFloat) {
        let widthConstraint = imageView.widthAnchor.constraint(equalToConstant: width)
        let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: width)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
    
    /**
     *  When the profile image is tapped, we go to the settings page which is the fifth tab in the tab bar.
     */
    @objc fileprivate func didTapProfileAreaBarButtonItem(_ sender: Any) {
        if let stylendarViewController = self as? STStylendarViewController, stylendarViewController.state == .global {
            stylendarViewController.delegate?.didTapProfileArea?(sender)
        } else {
            tabBarController?.selectedIndex = 4
        }
    }
}

extension UIViewController {
    /**
     *  Updates the profile image bar button item.
     */
    func updateProfileImageBarButtonItem() {
        guard let profileImageBarButtonItem = navigationItem.leftBarButtonItems?[0] else { return }
        guard let profileImageView = profileImageBarButtonItem.customView as? UIImageView else { return }
        guard let profileImageUrl = STUser.shared.profileImageUrl, let url = URL(string: profileImageUrl) else { return }
        
        profileImageView.fade(with: url, errorImage: STImage.profileImagePlaceholder, completion: { [weak self] success in
            guard let strongSelf = self else { return }
            strongSelf.navigationItem.leftBarButtonItems?[0] = UIBarButtonItem(customView: profileImageView)
        })
    }
    
    /**
     *  Updates the profile image bar button item.
     */
    func updateNameBarButtonItem() {
        guard let nameBarButtonItem = navigationItem.leftBarButtonItems?[1] else { return }
        UIView.performWithoutAnimation {
            nameBarButtonItem.title = STUser.shared.name.first
        }
    }
}

