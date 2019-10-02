//
//  STStylendarData+Handler.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 15/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate

extension STStylendarViewController {
    /**
     *  Handles the response from Firebase when the `retrieveProfile` request was finished.
     */
    func handle(_ snapshots: [DataSnapshot]) {
        /**
         *  In normal circumstances, we should have the user's profile retrieved correctly. However, we may never know, so we alert the user if something nasty happens.
         */
        guard snapshots[0].exists(),
            let user = snapshots[0].value as? [String:Any],
            let createdAt = user[STUser.createdAt] as? String,
            let isStylendarPublic = (user[STUser.privacy.node] as? [String:AnyObject])?[STUser.privacy.isStylendarPublic] as? Bool else {
                dismissLoadingState()
                STAlert.top(STString.networkError, isPositive: false)
                return
        }
        /**
         *  Because the stylendar can be empty, there's no error when it doesn't exist.
         */
        var stylendar = [String:Any]()
        if let stylendarValue = snapshots[1].value as? [String:Any] {
            stylendar = stylendarValue
        }

        /**
         *  Appends the profile because we now have all the data we need (the `uid`, the `name` and `profileImageUrl` inside the `data` object were added
         *  before the view controller was pushed in the navigation controller.
         */
        data.isStylendarPublic = isStylendarPublic
        data.createdAt = createdAt
        data.selector.createdAt = createdAt
        appendProfile()
        
        /**
         *  Decide if the self user is following or not the current stylendar's owner.
         *
         *  Raw values:
         *  0: not following
         *  1: pending follow request
         *  2: following
         */
        if let followingSnapshot = snapshots[2].children.allObjects.first as? DataSnapshot, let following = followingSnapshot.value as? [String:AnyObject], let _ = following[STUser.uid] as? String {
            data.isUserFollowed = .following
        } else {
            /**
             *  Even if the chance for the `accepted` field to be missing is low, we want to accommodate as many cases as possible.
             */
            if let requestSnapshot = snapshots[3].children.allObjects.first as? DataSnapshot, let request = requestSnapshot.value as? [String:AnyObject], let _ = request[STUser.uid] as? String {
                data.isUserFollowed = .pending
            } else {
                data.isUserFollowed = .notfollowing
            }
        }
        
        appendFollowButton()
        appendStylendar(stylendar)
    }
    
    /**
     *  We always wish to update teh current highlighted day if the user had the app in the background and they didn't kill it.
     */
    @objc func updateHighlightedDay() {
        /**
         *  We don't need to run this method if this is the first initialization of the view controller, that's because the lazy var
         *  'start' is not yet generated and calling `data.selector.start` will mess up the system.
         */
        guard let _ = data.createdAt else { return }
        
        let oldTodayIndex = data.selector.todayIndex
        /**
         *  We don't wish to verify the today index on every collection view cell display.
         */
        let difference = Date() - data.selector.start
        guard
            let todayIndex = difference.in(.day),
            oldTodayIndex != todayIndex
        else { return }
        data.selector.todayIndex = todayIndex
        
        tableView.reloadRows(at: [IndexPath(row: oldTodayIndex, section: 0), IndexPath(row: todayIndex, section: 0)], with: .none)
    }
}

extension STStylendarViewController {
    /**
     *  Sets the information on the views and updates the selector's `createdAt` variable.
     */
    func appendProfile() {
        /**
         *  The mini profile in the top left corner.
         */
        appendProfileAreaBarButtonItem(name: data.user.name.first, profileImageUrl: data.user.profileImageUrl)
    
        /**
         *  Generate the stylendar.
         */
        data.selector.gen()
        
        /**
         *  Refresh the UI.
         */
        tableView.reloadData()
    }
    
    /**
     *  If this is a global stylendar, we have to append the follow button in the top right corner.
     */
    func appendFollowButton() {
        guard let uid = data.user.uid else { return }
        let followButton = STFollowButton(uid: uid, isUserFollowed: data.isUserFollowed, isStylendarPublic: data.isStylendarPublic)
        followButton.delegate = self
        
        /**
         *  @located in STStylendarNavigationBarController.swift
         */
        appendFollowBarButtonItem(followButton)
    }
    
    /**
     *  Handles the data retrieved from Firebase.
     */
    func appendStylendar(_ stylendarValue: Any?) {
        defer { dismissLoadingState() }
        
        /**
         *  If the stylendar is not public and the owner is not followed by the user, we show the lock.
         *
         *  Observation: we dropped the support for DZNEmptyDataSource here because it didn't fit into the logic of the Stylendar. The frame of the root table view is double
         *  than the screen's width, therefore the no data view would've been placed somewhere around the right edge of the screen. We naturally didn't want this, so we could
         *  either edit the constraint programatically to make the table view as the screen width or we could drop the empty data set and create an overlap view which stay
         *  hidden all the time except for the following guard scenario else case. We chose the latter.
         *
         *  Then, important to note too is that the page isn't dynamic, which means that if the stlyendar's owner accept the follow request, the view won't automatically update
         *  to display the data now because the user is a trustworthy follower, thus requiring us to hide the overlapped view and so on and so forth.
         */
        guard data.isStylendarPublic == true || data.isUserFollowed == .following else {
            appendTableEmptyView()
            return
        }
        
        var stylendar = [String:[String:[String:String]]]()
        if let value = stylendarValue as? [String:[String:[String:String]]] { stylendar = value }
        
        /**
         *  We have to parse the data as Firebase returns it as a tree.
         *
         *  We have to clearfix the `year`, `month` and `day` keys because they were all prefixed with `y`, `m`, and `d`, so that we don't store data as arrays. Read more about
         *  it here: https://stackoverflow.com/questions/15534917/why-do-firebase-collections-seem-to-begin-with-a-null-row
         */
        for (year, monthDict) in stylendar {
            for (month, dayDict) in monthDict {
                for (day, url) in dayDict  {
                    data.urls[STDate.format(year, month, day)] = url
                }
            }
        }
        /**
         *  Auto scroll the stylendar.
         */
        appendAutoScroll()
        
        /**
         *  Calling `tabelView.reloadData` does not trigger any collection view update because they are child views of the table view cells. Thus, we have to manually trigger the
         *  update and we do this by iterating over the visible cells on the screen (the rest will be automatically updated - see STStylendarTableViewCell).
         */
        guard let tableIndexPaths = tableView.indexPathsForVisibleRows, tableIndexPaths.isEmpty == false else { return }
        for tableIndexPath in tableIndexPaths {
            guard let tableViewCell = tableView.cellForRow(at: tableIndexPath) as? STStylendarTableViewCell else { continue }
            let collectionIndexPaths = tableViewCell.collectionView.indexPathsForVisibleItems
            
            var indexPaths = [IndexPath]()
            for collectionIndexPath in collectionIndexPaths {
                let index = (tableIndexPath.row * 7) + collectionIndexPath.row
                if let path = data.selector.holder.paths[index], let _ = data.urls[path] {
                    indexPaths.append(collectionIndexPath)
                }
            }
            tableViewCell.collectionView.reloadItems(at: indexPaths)
        }
    }
}

