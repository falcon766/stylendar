//
//  STPeopleNetwork+Follow.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 21/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

extension STPeopleViewController {
    
    /**
     *  Updates the `accepted` state of one edge (follower + following).
     */
    func update(edge: STEdge, accepted: Bool, completion: (() -> ())?) {
        guard let selfUid = Auth.auth().currentUser?.uid else { return }
        
        /**
         *  Disregarding the case, we have to delete the request entry.
         */
        let requestRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.requests.node)
            .child(selfUid)
            .child(edge.pushId)
        let requestPromise = PromiseKit.wrap{requestRef.removeValue(completionBlock: $0)}
        
        /**
         *  Makes the update following the rules:
         *
         *  `accepted`:true -> edge is active and user A is following user B.
         *  `accepted`:false -> edge is not active yet because user B has yet to accept user A's follow request.
         *  `accepted`:nil -> no edge between the users and this is the state on which the data gets reverted if user B denies user A's follow request.
         *
         *  Observation: this sytem lets user A follow user B again an infinite number of times if B refused the request(s).
         */
        if accepted {
            /**
             *  We create the entry because the edge isn't created before follow request approval.
             */
            let followerRef = STDatabase
                .shared
                .ref
                .child(STVeins.node)
                .child(STVeins.followers.node)
                .child(selfUid)
                .childByAutoId()
            let followingRef = STDatabase
                .shared
                .ref
                .child(STVeins.node)
                .child(STVeins.following.node)
                .child(edge.user.uid!)
                .childByAutoId()
            
            let followerUpdate = [
                STUser.uid: edge.user.uid ?? "",
                STUser.name.node: edge.user.name.first ?? "",
                STUser.username: edge.user.username ?? "",
                STUser.profileImageUrl: edge.user.profileImageUrl ?? ""
            ]
            let followingUpdate = [
                STUser.uid: selfUid,
                STUser.name.node: STUser.shared.name.first ?? "",
                STUser.username: STUser.shared.username ?? "",
                STUser.profileImageUrl: STUser.shared.profileImageUrl ?? ""
            ]
            
            /**
             *  Kickstart the promises.
             */
            let followerPromise = PromiseKit.wrap{followerRef.updateChildValues(followerUpdate, withCompletionBlock: $0)}
            let followingPromise = PromiseKit.wrap{followingRef.updateChildValues(followingUpdate, withCompletionBlock: $0)}
            
            firstly {
                when(fulfilled: followerPromise, followingPromise, requestPromise)
                }.then { (refs) -> Void in
                    completion?()
                    self.updateEdgeSuccess()
                }.catch { (error) in
                    self.updateEdgeFailure(error)
                    
            }
        } else {
            /**
             *  If the request wasn't accepted, all we have to do is delete the entry.
             */
            firstly {
                requestPromise
                }.then { (ref) -> Void in
                    completion?()
                    self.updateEdgeSuccess()
                }.catch { (error) in
                    self.updateEdgeFailure(error)
            }
        }
    }
    
    /**
     *  Called when the request above succeeded.
     */
    fileprivate func updateEdgeSuccess() {
        self.updateFollowRequestsBadge(segmentedControl.badgeValue(for: state.rawValue) - 1)
        self.tableView.reloadData()
    }
    
    /**
     *  Called when the request above failed.
     */
    fileprivate func updateEdgeFailure(_ error: Error) {
        STError.playground(error)
    }
}

