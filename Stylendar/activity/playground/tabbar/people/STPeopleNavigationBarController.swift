//
//  STPeopleNavigationBarController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 03/09/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STPeopleViewController {
    /**
     *  Appends the configured navigation bar to the view controller.
     */
    func appendNavigationBar() {
        navigationItem.title = NSLocalizedString("People", comment: "")

        /**
         * Annoying iOS 13 black at notch of iphone x. Read more: https://stackoverflow.com/questions/56556254/in-ios13-the-status-bar-background-colour-is-different-from-the-navigation-bar-i?noredirect=1&lq=1
         */
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .main
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.shadowImage = UIColor.main.as1ptImage()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barTintColor = .main
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.shadowImage = UIColor.main.as1ptImage()
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
    }
}
