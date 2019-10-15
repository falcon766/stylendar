//
//  SearchViewController+SearchBar.swift
//  Stylendar
//
//  Created by Apple on 10/15/19.
//  Copyright © 2019 Paul Berg. All rights reserved.
//

import Foundation
import UIKit


//MARK: - UISearchBarDelegate
extension STPeopleViewController{

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchViewController?.updateSearchResults(textSearch: "")
        btnCancelSearch?.isHidden = false
        vSearchContainer?.isHidden = false
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchViewController?.tableView.backgroundColor = UIColor.clear
        dismissSearchViewController()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchViewController?.updateSearchResults(textSearch: searchText)
    }
    
}

//MARK: - STSearchViewControllerDelegate
extension STPeopleViewController {
    func didTap(_ user: STUser) {
        dismissSearchViewController()
        STIntent.gotoStylendar(sender: self, user: user)
    }
    
    func dismissSearchViewController()  {
        btnCancelSearch?.isHidden = true
        vSearchContainer?.isHidden = true
        searchBar?.text = ""
        view.endEditing(true)
    }
}
