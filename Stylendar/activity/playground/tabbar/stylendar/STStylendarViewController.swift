//
//  STStylendarViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

enum STStylendarState: Int {
    case personal = 1,
    global = 2
}

@IBDesignable
class STStylendarViewController: STViewController {
    
    /**
     *  Tells if the instance of the view controller it the self stylendar or someone else's one.
     */
    var state: STStylendarState = .personal
    
    /**
     *  The source of truth for the view controller.
     */
    var data = STStylendarData()
    
    /**
     *  As the name suggests, tells if the stylendar was already retrieved or not.
     */
    var triggeredStylendarRequest = false
    
    /**
     *  The views.
     */
    @IBOutlet weak var tableView: STTableView!
    @IBOutlet weak var tableEmptyView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var profileImageView: UIImageView!
    
    /**
     *  Sugar var to retrieve the follow button quickier.
     */
    var followButton: STFollowButton? {
        get {
            return navigationItem.rightBarButtonItem?.customView as? STFollowButton
        }
    }
    
    /**
     *  The color follows the state and the data of the stylendar.
     */
    var color: UIColor! {
        didSet {
            self.animateColorChange()
        }
    }
    
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STViewController.swift
         */
        delegate = self
        
        /**
         *  @located in STStylendarTableViewController.swift
         */
        appendTableView()
        
        /**
         *  @located in STStylendarData.swift
         */
        startup()
    }
    
    
    /**
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STStylendarNavigationBarController.swift
         */
        appendNavigationBar()
        
        /**
         *  @located in STStylendarData+Handler.swift
         */
        updateHighlightedDay()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateHighlightedDay),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object:  nil)
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.updateHighlightedDay),
        name: UserNotificationsUpdateCurrentDateNotification,
        object:  nil)
        /**
         * reload follow button after show profile of this person
         */
        appendFollowButton()
    }
    
    /**
     *  Override 'viewWillDisappear'.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                  object:  nil)
        NotificationCenter.default.removeObserver(self,
        name: UserNotificationsUpdateCurrentDateNotification,
        object:  nil)
    }
    
    /**
     *  Override 'willMove(toParentViewController:)'
     */
    override func willMove(toParentViewController parent: UIViewController?) {
        if parent == nil {
            navigationController?.navigationBar.barTintColor = .main
        }
        super.willMove(toParentViewController: parent)
    }
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
