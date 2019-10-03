//
//  STSearchTableViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

extension STSearchViewController {
    /**
     *  Appends the configured table view to the view controller.
     */
    func appendTableView() {
        tableView.register(UINib(nibName: String(describing: STUserTableViewCell.self), bundle: .main), forCellReuseIdentifier: "cell")
    }
}

extension STSearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? STUserTableViewCell else { return UITableViewCell() }
        
        /**
         *  Get the data item.
         */
        let user = data.users[indexPath.row]
        
        /**
         *  Set it on views.
         */
        cell.nameLabel.text = user.username
        
        if let imageUrlString = user.profileImageUrl, let imageUrl = URL(string: imageUrlString) {
            cell.profileImageView.fade(with: imageUrl, completion: { (success) in })
        } else {
            cell.profileImageView.image = nil
        }
        
        /**
         *  Some settings.
         */
        cell.profileView.isUserInteractionEnabled = false
        cell.profileImageView.isUserInteractionEnabled = false
        
        return cell
    }
}

extension STSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return STUserTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /**
         *  Get the data item and pass it to the delegate.
         *
         *  The guard's purpose is to shield some racing conditions (the user taps the cell before the UI refreshes).
         */
        guard indexPath.row < data.users.count else { return }
        let user = data.users[indexPath.row]
        searchDelegate?.didTap(user)
    }
}

/**
 *  The empty data set and delegate.
 */
extension STSearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return state == .idle
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "ic_cancel")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .main
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.montserrat(size: 13),
                          NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let message = NSLocalizedString("No users found with the given criteria", comment: "")
        return NSAttributedString(string: message, attributes: attributes)
    }
}

