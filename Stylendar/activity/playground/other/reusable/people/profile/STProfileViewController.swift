//
//  STProfileViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STProfileViewController: STViewController {
    
    /**
     *  The source of truth for the view controller.
     */
    var data = STProfileData()
    var followDelegate: STFollowButtonDelegate?
    var isStylendarPublic = true
    var isUserFollowed: STFollowState = .notfollowing
    
    /**
     *  The views.
     */
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followButton: STFollowButton!

    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STViewController.swift
         */
        listView = scrollView
        appendLoadingState()
        
        /**
         *  @located in STProfileNavigationBarController.swift
         */
        appendNavigationBarButton()
        
        /**
         *  @located in STProfileScrollViewController.swift
         */
        appendScrollView()
        
        /**
         *  @located in STProfileNetwork.swift
         */
        retrieve()
        /**
         * setup follow button
         */
        setupFollowButton()
        
//        dump(UIFont.familyNames)
    }
    
    
    /**
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STProfileNavigationBarController.swift
         */
        appendNavigationBar()
        
        /**
         *  @located in STProfileAnimationController.swift
         */
        appendNavigationBarColor()
    }
    

    /**
     *  Override 'willMove(toParentViewController:)'
     */
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            /**
             *  Only reset to pink if it's necessary (the stylendar view controller requires it).
             */
            
            if  let count = navigationController?.viewControllers.count,
                let stylendarViewController = navigationController?.viewControllers[count-2] as? STStylendarViewController,
                stylendarViewController.color == .appPink {
                navigationController?.navigationBar.barTintColor = .appPink
            }
        }
        super.willMove(toParentViewController: parent)
    }
    
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupFollowButton() {
        guard let uid = data.user.uid else { return }
        followButton.setup(uid: uid, isUserFollowed: isUserFollowed, isStylendarPublic: isStylendarPublic, style: .full)
        followButton.delegate = self
    }
}

extension STProfileViewController: STFollowButtonDelegate {
    func didTapFollowButton(_ followButton: STFollowButton) {
        let state = followButton.isUserFollowed
        var followers = Int(followersLabel.text ?? "0") ?? 0
        followers = state == .notfollowing && isStylendarPublic ? followers + 1 :  state == .following ? followers - 1 : followers
        followersLabel.text = "\(followers)"
        followDelegate?.didTapFollowButton(followButton)
    }
}
