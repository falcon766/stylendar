//
//  STFeedData+Handler.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 19/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate

extension STFeedViewController {
    /**
     *  Fills the list view with the data retrieved from Firebase.
     */
    func handle(_ snapshot: DataSnapshot) {
        print("\(#function): \(snapshot.value ?? "snapshot is nil bro")")
        
        var posts = [STPost]()
        var length: Int = 0
        
        /**
         *  Because `snapshot.val()` is not iterable, we use `snapshot.children`.
         */
        let enumerator = snapshot.children
        while let postSnapshot = enumerator.nextObject() as? DataSnapshot {
            if let dictionary = postSnapshot.value as? [String:AnyObject] {
                let post = STPost(from: dictionary)
                post.id = postSnapshot.key
                posts.append(post)
                /**
                 *  We count the elemenths like this so that we avoid the edge cases where `childrenCount` retrieves a different values than the actual iterated snapshots count.
                 */
                length += 1
            }
        }
        
        /**
         *  Dismiss the loading state and the refresh control view and clear the containers if the 'dataRound' is 0.
         */
        if pagination.dataRound == 0 {
            dismissLoadingState()
            data.dates.removeAll()
            data.posts.removeAll()
        }
        /**
         *  Set the pagination's `isBusy` to false because the work is done. We also increment the pagination's `dataRound`.
         */
        pagination.isBusy = false
        pagination.dataRound += 1
        
        /**
         *  We reverse the array because, even if we retrieved the last elements, Firebase returns them in
         *  ascending order, so that small set is ascendently ordered.
         */
        posts = posts.reversed()
        
        /**
         *  We purposely retrieve `itemsPerPage` + 1 elements because the last element is going to be our offset for the next page query.
         *  Of course, if there aren't `itemsPerPage`+ 1 elements, it means there aren't that many posts in the database, so we set
         *  `stillHasToGetData` on `false`.
         */
        if length == pagination.itemsPerPage + 1 {
            let index = length - 1
            let date = posts[index].date.string(format: STDateFormat.default.rawValue)
            pagination.pivot = STPair(key: posts[index].id, value: date)
            posts.remove(at: index)
        } else {
            pagination.stillHasToGetData = false
        }
        
        /**
         *  Merge the arrays and update the UI.
         */
        for post in posts {
            /**
             *  If the array is empty or it is a different date than the previous one, we have to add it as a new one so that the collection view will display
             *  a new section.
             */
            let date = STDate.format(post.date.year, post.date.month, post.date.day)
            let length = data.dates.count
            if data.dates.isEmpty || date != data.dates[length-1] {
                data.dates.append(date)
                data.posts[date] = [STPost]()
            }
            
            /**
             *  Let's append the new post.
             */
            if let _ = data.posts[date] {
                data.posts[date]!.append(post)
            } else {
                data.posts[date] = [post]
            }
        }
        collectionView.reloadData()
    }
    
    
    /**
     *  Checks if there's any value on the tab bar item's badge, clears it if so and reloads the list view. This happens only if the badge has
     *  a number on it. Otherwise, simply retrieve the notification list as perhaps this is the first time the page was opened.
     *
     *  Observation: If the badge value is empty, we do this if only there's still data to be retrieved.
     */
    func fillListView() {
        if let _ = navigationController?.tabBarItem.badgeValue, pagination.dataRound > 0 {
            reload()
        } else {
            if pagination.stillHasToGetData {
                retrievePosts()
            }
        }
        
        /**
         * @located in STViewController+TabBar.swift
         */
        clearBadge()
    }
    
    
    /**
     *  Reloads the list view after some action which requires this to occur. Example: refresh control view.
     */
    func reload() {
        /**
         * Clears the containers and the state.
         */
        pagination.dataRound = 0
        pagination.isBusy = false
        pagination.pivot = STPair()
        pagination.stillHasToGetData = true
        
        /**
         * Retrieving the data again.
         */
        retrievePosts()
    }
}

