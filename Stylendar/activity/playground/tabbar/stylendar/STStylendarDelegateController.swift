//
//  STStylendarDelegateController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import LKAlertController
import PromiseKit

extension STStylendarViewController: STViewControllerDelegate {
    /**
     *  Called when the profile area (from the navigation bar) was tapped.
     */
    func didTapProfileArea(_ sender: Any) {
        let storyboard = UIStoryboard(name: String(describing: STProfileViewController.self), bundle: .main)
        guard let profileViewController = storyboard.instantiateInitialViewController() as? STProfileViewController else { return }
        profileViewController.data.user = data.user
        profileViewController.followDelegate = self
        profileViewController.isStylendarPublic = data.isStylendarPublic
        profileViewController.isUserFollowed = data.isUserFollowed
        show(profileViewController, sender: self)
    }
    
    /**
     *  Called when the user's profile was update.
     */
    func didUpdateProfileImage() {
        updateProfileImageBarButtonItem()
    }
    
    func didUpdateName() {
        updateNameBarButtonItem()
    }
}

extension STStylendarViewController: STPostMultipleViewControllerDelegate {
    /**
     *  We allow the user to delete the post from the post view too. Here, we handle the user's action (remove the post).
     *
     *  Be aware that we're able to directly call `remove()` only because we set the `tableIndexPath` and the `collectionIndexPath` before presenting the multiple post
     *  view controller. Otherwise, we'd have to generate the indexPaths.
     */
    func didTapRemoveButton() {
        remove()
    }
}

extension STStylendarViewController: STFollowButtonDelegate {
    /**
     *  The follow button delegate. Because the write and remove operations are so different in Firebase, we had to make two different functions.
     */
    func didTapFollowButton(_ followButton: STFollowButton) {
        let state = followButton.isUserFollowed
        followButton.toggleState()
        state != .notfollowing ? (state == .following ? removeFollowEdge() : removePendingEdge()) : writeFollowEdge()
    }
}
