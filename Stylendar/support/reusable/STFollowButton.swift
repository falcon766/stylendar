//
//  STFollowButton.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 17/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
 *  The idea is that we don't make the networking internally because that'd break the architecture pattern. Instead, we alert the controller to make the necessary updates.
 */
protocol STFollowButtonDelegate: class {
    func didTapFollowButton(_ followButton: STFollowButton)
}

/**
 *  Not being used, added here only for reference.
 */
enum STFollowState: Int {
    case notfollowing = 0,
    pending = 1,
    following = 2
}
enum STFollowStyle {
    case short
    case full
}
class STFollowButton: UIButton {
    fileprivate static let followText: String = "FOLLOW"
    fileprivate static let pendingText: String = "Cancel request"
    fileprivate static let fullPendingText: String = "Cancel pending follow request"
    fileprivate static let unfollowText: String = "UNFOLLOW"
    
    /**
     *  We internally handle the state of the follow button. This has to be synced with the display text: "+" or "-".
     *
     *  0: not following
     *  1: pending follow request
     *  2: following
     */
    var isUserFollowed: STFollowState = .notfollowing
    var isStylendarPublic: Bool = false
    var style: STFollowStyle = .short
    
    weak var delegate: STFollowButtonDelegate?
    var uid: String?
    
    /**
     *  We initialize the button. We set by default 105 because that's the width a button needs to accomodate `UNFOLLOW` on the bold
     *  system font with 17 pts size (tested on IB). Anyway, it's actually 97, but we've added 8 pts just in case for margins.
     */
    init(uid: String, isUserFollowed: STFollowState, isStylendarPublic: Bool, style: STFollowStyle = .short) {
        super.init(frame: CGRect(x: 0, y: 0, width: 120, height: 32))
        setup(uid: uid, isUserFollowed: isUserFollowed, isStylendarPublic: isStylendarPublic, style: style)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel?.sizeToFit()
        
        addTarget(self, action: #selector(toggle), for: .touchDown)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(toggle), for: .touchDown)
    }

    func setup(uid: String, isUserFollowed: STFollowState, isStylendarPublic: Bool, style: STFollowStyle = .short) {
        self.uid = uid
        self.isUserFollowed = isUserFollowed
        self.isStylendarPublic = isStylendarPublic
        self.style = style
        /**
         *  Initial configuration.
         */
        setTitle()
    }
    
    /**
     *  Sugar methods to easily change the text when the state changes.
     */
    func setTitle() {
        isUserFollowed != .following ? (isUserFollowed == .notfollowing ? setFollowTitle() : setPendingTitle()) : setUnfollowTitle()
    }
    func setFollowTitle() {
        setTitle(STFollowButton.followText, for: .normal)
    }
    func setPendingTitle() {
        let text = style == .short ? STFollowButton.pendingText : STFollowButton.fullPendingText
        setTitle(text.uppercased(), for: .normal)
    }
    func setUnfollowTitle() {
        setTitle(STFollowButton.unfollowText, for: .normal)
    }
}

extension STFollowButton {
    /**
     *  Called when the user touches the button.
     */
    @objc func toggle() {
        guard let _ = uid else {
            print("\(#function): userId can't be empty if you want the follow button's delegate to trigger its methods.")
            return
        }
        delegate?.didTapFollowButton(self)
    }
    
    /**
     *  Sugar method to toggle between the states:
     *
     *  ANY CASE
     *      .following -> .notfollowing
     *
     *  IF isPublicStylendar == true
     *      .notfollowing -> .following
     *  ELSE
     *      .notfollowing -> .pending
     */
    func toggleState() {
        if isUserFollowed != .notfollowing {
            isUserFollowed = .notfollowing
        } else {
            isUserFollowed = isStylendarPublic ? .following : .pending
        }
        setTitle()
    }
    
}
