//
//  STPeopleViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 29/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

enum STPeopleViewControllerState: Int {
    case followers = 0,
    following = 1,
    requests = 2
}
class STPeopleViewController: STViewController {
    
    /**
     *  Tells which tab is currently selected in the segmented control.
     */
    var state: STPeopleViewControllerState = .followers {
        didSet {
            guard oldValue != state else { return }
            /**
             *  When a notification comes and redirects the user to a specific state, the segmented control might get confused. We have to update the UI properly.
             *
             *  Be very careful with the IBOutlets here, because the state can be changed from outside the view controller, before `viewDidLoad` is called. This happens
             *  only when a push notifications comes and wants to open the page.
             *
             *  The crash: https://fabric.io/vansoftware/ios/apps/com.stylendar/issues/59a31ea0be077a4dccb374ca?time=last-seven-days
             */
            guard isViewLoaded else { return }
            segmentedControl?.selectedSegmentIndex = state.rawValue
            
            /**
             *  If there is already data for the new state, we don't retrieve a new set, yet we simply refresh the UI. In the other case, or when
             *  the state change was triggered by a push, we try to retrieve the data.
             */
            if !data.shouldRedirectToStylendar {
                if !data.edges[state].isEmpty {
                    tableView.reloadData()
                } else {
                    retrieveUsers()
                }
            } else {
                reload()
            }
        }
    }
    
    /**
     *  The source of truth for this view controller.
     */
    var data = STPeopleData()
    var paginations: [STPagination] = [STPagination(), STPagination(), STPagination()]
    
    /**
     *  The views.
     */
    @IBOutlet weak var segmentedControl: BadgeSegmentControl!
    @IBOutlet weak var tableView: STTableView!
    var searchController: UISearchController!

    /**
     *  Used to refresh the data on the view controller.
     */
    lazy var refreshControlView: UIRefreshControl = {
        let refreshControlView = UIRefreshControl()
        refreshControlView.addTarget(self, action: #selector(self.didDragRefreshControlView(_:)), for: .valueChanged)
        refreshControlView.tintColor = .white
        return refreshControlView
    }()
    
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STViewController.swift
         */
        listView = tableView
        refreshControl = refreshControlView
        shouldBackButtonTextBeHidden = false
        appendLoadingState()
        
        /**
         *  @located in STPeopleTableViewController.swift
         */
        appendTableView()
        
        /**
         *  @located in STPeopleSearchController.swift
         */
        appendSearchController()
        
        /**
         *  @located in STPeopleSegmentedControlController.swift
         */
        appendSegmentedControl()
        
        /**
         *  @located in STFeedData+Startup.swift
         */
        startup()
        
        /**
         *  @located in STPeopleNetwork.swift
         */
        retrieveUsers()
        monitorFollowRequests()
    }
    
    
    /**
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STPeopleNavigationBarController.swift
         */
        appendNavigationBar()
    }
    
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
