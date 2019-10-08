//
//  STPeopleSearchController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STPeopleViewController {
    /**
     *  Appends the configured search controller to the view controller.
     */
    func appendSearchController() {
        let storyboard = UIStoryboard(name: String(describing: STSearchViewController.self), bundle: .main)
        guard let searchViewController = storyboard.instantiateInitialViewController() as? STSearchViewController else { return }
        searchViewController.searchDelegate = self

        searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchResultsUpdater = searchViewController
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = .white
        searchController.searchBar.subviews[0].subviews.compactMap(){ $0 as? UITextField }.first?.tintColor = .white
        definesPresentationContext = true
        /**
         *  Annoying iOS 11 black bar bug solved. Read more: https://stackoverflow.com/questions/45350035/ios-11-searchbar-in-navigationbar
         */
        if #available(iOS 11.0, *) {
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
            navigationItem.searchController = searchController
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }
}

extension STPeopleViewController: STSearchViewControllerDelegate {
    func didTap(_ user: STUser) {
        STIntent.gotoStylendar(sender: self, user: user)
    }
}

extension STPeopleViewController: UISearchControllerDelegate {
    /**
     *  The search results update delegate.
     */
    func didDismissSearchController(_ searchController: UISearchController) {
        /**
         *  Horrible navigation controller + search controller push top layout guide 0 bug.
         *
         *  Read more: https://stackoverflow.com/questions/33011479/uitableview-with-uisearchcontroller-go-under-navbar-when-enter-in-a-result-view/38574531#38574531
         */
        navigationController?.pushViewController(UIViewController(), animated: false)
        navigationController?.popViewController(animated: false)
    }
}
