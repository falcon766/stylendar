//
//  STSearchViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 29/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Alamofire

protocol STSearchViewControllerDelegate: class {
    func didTap(_ user: STUser)
}

class STSearchViewController: STViewController, STSearchableViewController {
    /**
     *  The `STSearchableViewController` protocol.
     */
    var state: STSearchableViewControllerState = .startup {
        didSet {
            if state == .buffering {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                tableView.isScrollEnabled = false
            }
            
            if state == .idle {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                tableView.isScrollEnabled = true
            }
        }
    }

    /**
     *  Announces the sender class when an user was tapped.
     */
    weak var searchDelegate: STSearchViewControllerDelegate?
    
    /**
     *  The source of truth for this view controller.
     */
    var data = STSearchData()
    
    /**
     *  Used to display the data.
     */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STSearchTableViewController.swift
         */
        appendTableView()
        
        /**
         *  @located in STSearchData.swift
         */
        appendPaginationData()
    }
    
    
    /**
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
