//
//  STPeopleTableViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

extension STPeopleViewController {
    /**
     *  Appends the configured table view to the view controller.
     */
    func appendTableView() {
        tableView.register(UINib(nibName: String(describing: STUserTableViewCell.self), bundle: .main), forCellReuseIdentifier: "cell")
        
        /**
         *  Other configurations.
         */
        tableView.addSubview(refreshControlView)
    }
    
    /**
     *  The refresh control view was dragged.
     */
    @objc func didDragRefreshControlView(_ sender: Any) {
        reload()
    }
}

extension STPeopleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.edges[state].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? STUserTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.indexPath = indexPath
        
        /**
         *  Get the data item.
         */
        let edge = data.edges[state][indexPath.row]
        
        /**
         *  Set the data on the views.
         */
        cell.nameLabel.text = edge.user.username
        
        if let imageUrlString = edge.user.profileImageUrl, let imageUrl = URL(string: imageUrlString) {
            cell.profileImageView.fade(with: imageUrl, completion: { (success) in })
        } else {
            cell.profileImageView.image = nil
        }

        /**
         *  This allows the user to accept or deny a follow request.
         */
        if state != .requests {
            cell.buttonView.isHidden = true
        } else {
            cell.buttonView.isHidden = false
        }
        
        return cell
    }
}

extension STPeopleViewController: UITableViewDelegate, STUserTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return STUserTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        /**
         *  The only case where we disallow going to the stylendar in this page is when the user views the follow requests. That list is only for accepting or rejecting.
         */
        guard state != .requests else { return }
        
        /**
         *  Get the data item and make the transition afterwards.
         */
        let edge = data.edges[state][indexPath.row]
        STIntent.gotoStylendar(sender: self, user: edge.user)
    }
    
    func didTapUserProfileArea(at indexPath: IndexPath) {
        /**
         *  Get the data item and make the transition afterwards.
         */
        let edge = data.edges[state][indexPath.row]
        STIntent.gotoStylendar(sender: self, user: edge.user)
    }
    
    func didRespondToFollowRequest(at indexPath: IndexPath, accepted: Bool) {
        /**
         *  Get the data item, send the request and update the data and the UI afterwards.
         */
        let edge = data.edges[state][indexPath.row]
        update(edge: edge, accepted: accepted, completion: { [unowned self] in
            self.data.edges[self.state].remove(at: indexPath.row)
        })
    }
}

/**
 *  The empty data set and delegate.
 */
extension STPeopleViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return data.edges[state].count == 0
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
        
        /**
         *  We display a different message based upon the current state.
         */
        var message = ""
        switch state {
        case .followers:
            message = NSLocalizedString("Sadly, you don't have any followers", comment: "")
            break
        case .following:
            message = NSLocalizedString("Sadly, you don't follow anyone", comment: "")
            break
        case .requests:
            message = NSLocalizedString("All set! No more follower requests to review.", comment: "")
            break
        }
        return NSAttributedString(string: message, attributes: attributes)
    }
}

