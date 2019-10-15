//
//  STStylendarNetwork+Follow.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 17/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

extension STStylendarViewController {
    
    /**
     *  Appends the entries in the `/veins/followers` and `/veins/following`.
     */
    func writeFollowEdge() {
        guard let uid = data.user.uid, let selfUid = Auth.auth().currentUser?.uid else { return }
        
        /**
         *  Create the refs.
         *
         *  Observation: we don't create any following entry if the stylendar isn't public.
         */
        let followerRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(!data.isStylendarPublic ? STVeins.requests.node : STVeins.followers.node)
            .child(uid)
            .childByAutoId()
        let followerUpdate: [String:Any] = [
            STUser.uid: selfUid,
            STUser.name.node: STUser.shared.name.first ?? "",
            STUser.username: STUser.shared.username ?? "",
            STUser.profileImageUrl: STUser.shared.profileImageUrl ?? ""
        ]
        
        let followingRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.following.node)
            .child(selfUid)
            .childByAutoId()
        let followingUpdate: [String:Any] = !data.isStylendarPublic ? [String:Any]() : [
            STUser.uid: uid,
            STUser.name.node: data.user.name.first ?? "",
            STUser.username: data.user.username ?? "",
            STUser.profileImageUrl: data.user.profileImageUrl ?? ""
        ]
        
        /**
         *  Create the promises.
         */
        let followerPromise = PromiseKit.wrap{followerRef.updateChildValues(followerUpdate, withCompletionBlock: $0)}
        let followingPromise = PromiseKit.wrap{followingRef.updateChildValues(followingUpdate, withCompletionBlock: $0)}
        
        /**
         *  Kickstart the promises.
         */
        firstly {
            when(fulfilled: followerPromise, followingPromise)
            }.then {[weak self] (results) -> Void in
                self?.data.isUserFollowed = self?.data.isStylendarPublic ?? true ? .following : .pending
//                print("\(#function): follow request finished successfully")
            }.catch { (error) in
                self.failure(error)
        }
    }
    
    /**
     *  Removes the user's entries from `/veins/requests`.
     */
    func removePendingEdge() {
        guard let uid = data.user.uid, let selfUid = Auth.auth().currentUser?.uid else { return }
        
        /**
         *  Create the refs.
         */
        let requestReusableRef =  STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.requests.node)
            .child(uid)
        let requestRef = requestReusableRef
            .queryOrdered(byChild: STUser.uid)
            .queryEqual(toValue: selfUid)
            .queryLimited(toFirst: 1)
        
        /**
         *  Create the promise.
         */
        let requestPromise = PromiseKit.wrap{requestRef.observeSingleEvent(of: .value, with: $0)}
        
        firstly {
            requestPromise
            }.then{ (snapshot) -> Promise<(Error?, DatabaseReference)> in
                /**
                 *  The `children` count is always 1 because we set `queryLimited(toFirst: 1)` above.
                 */
                guard let requestPushId = (snapshot.children.allObjects.first as? DataSnapshot)?.key else {
                    throw STError.networkError
                }
                
                /**
                 *  Because we firstly have to get the Firebase push keys, we had to create this cascading system.
                 */
                let requestDeleteRef = requestReusableRef
                    .child(requestPushId)
                let requestDeletePromise = PromiseKit.wrap{requestDeleteRef.removeValue(completionBlock: $0)}
                
                return requestDeletePromise
            }.then {[weak self] (results) -> Void in
                self?.data.isUserFollowed = .notfollowing
//                print("\(#function): follow request finished successfully")
            }.catch { (error) in
                self.failure(error)
        }
    }
    
    /**
     *  Removes the user's entries from `/veins/followers` and `/veins/following`.
     */
    func removeFollowEdge() {
        guard let uid = data.user.uid, let selfUid = Auth.auth().currentUser?.uid else { return }
        
        /**
         *  Create the refs.
         */
        let followerReusableRef =  STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.followers.node)
            .child(uid)
        let followerRef = followerReusableRef
            .queryOrdered(byChild: STUser.uid)
            .queryEqual(toValue: selfUid)
            .queryLimited(toFirst: 1)
        
        let followingReusableRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.following.node)
            .child(selfUid)
        let followingRef = followingReusableRef
            .queryOrdered(byChild: STUser.uid)
            .queryEqual(toValue: uid)
            .queryLimited(toFirst: 1)
        
        let newsfeedReusableRef =  STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.newsfeed.node)
            .child(selfUid)
        
        let newsfeedRef = newsfeedReusableRef
            .queryOrdered(byChild: STUser.uid)
            .queryEqual(toValue: uid)
        
        /**
         *  Create the promises.
         */
        let followerPromise = PromiseKit.wrap{followerRef.observeSingleEvent(of: .value, with: $0)}
        let followingPromise = PromiseKit.wrap{followingRef.observeSingleEvent(of: .value, with: $0)}
        let newfeedPromise = PromiseKit.wrap{newsfeedRef.observeSingleEvent(of: .value, with: $0)}

        firstly {
            when(fulfilled: followerPromise, followingPromise, newfeedPromise)
            }.then{ (snapshots) -> Promise<((Error?, DatabaseReference), (Error?, DatabaseReference))> in
                /**
                 *  The `children` count is always 1 because we set `queryLimited(toFirst: 1)` above.
                 */
                guard let followerPushId = (snapshots.0.children.allObjects.first as? DataSnapshot)?.key,
                      let followingPushId = (snapshots.1.children.allObjects.first as? DataSnapshot)?.key,
                      let feedPushIds = (snapshots.2.children.allObjects as? [DataSnapshot])?.map({$0.key}) else {
                    throw STError.networkError
                }
                
                /**
                 *  Because we firstly have to get the Firebase push keys, we had to create this cascading system.
                 */
                let followerDeleteRef = followerReusableRef
                    .child(followerPushId)

                let followingDeleteRef = followingReusableRef
                    .child(followingPushId)
                
                var newfeedDeleteRefs:[DatabaseReference] = []
                feedPushIds.forEach({ (id) in
                    newfeedDeleteRefs.append(newsfeedReusableRef.child(id))
                })
                    
                
                let followerDeletePromise = PromiseKit.wrap{followerDeleteRef.removeValue(completionBlock: $0)}
                let followingDeletePromise = PromiseKit.wrap{followingDeleteRef.removeValue(completionBlock: $0)}

                newfeedDeleteRefs.forEach { (feed) in
                    feed.removeValue { error, _ in
                        print("Delete error:\(error)")
                    }
                }

                return when(fulfilled: followerDeletePromise, followingDeletePromise)
            }.then {[weak self] (results) -> Void in
//                print("\(#function): follow request finished successfully")
                
                /**
                 *  We wish to display the empty table view if the owner's account is set to private and now the user isn't a follower anymore.
                 */
                guard let strongSelf = self else {return}
                strongSelf.data.isUserFollowed = .notfollowing
                if !strongSelf.data.isStylendarPublic { strongSelf.appendTableEmptyView() }
            }.catch { (error) in
                self.failure(error)
        }
    }

    
    /**
     *  Called when one of the functions above failed.
     */
    fileprivate func failure(_ error: Error) {
        /**
         *  We toggle the state because the UI is updated instantly in the `STFollowButtonDelegate` method `didTapFollowButton` to let the user notice the change immediately.
         *  However, if something went wrong, we go back to the initial state and alert him that nasty issues occurred.
         */
        followButton?.toggleState()
        STError.playground(error)
    }
}
