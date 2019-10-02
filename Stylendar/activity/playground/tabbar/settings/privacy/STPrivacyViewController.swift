//
//  STPrivacyViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STPrivacyViewController: UITableViewController {
    
    /**
     *  The source of truth for the view controller.
     */
    var data = STPrivacyData()
    
    /**
     *  Self-explanatory names.
     */
    @IBOutlet weak var publicTableViewCell: UITableViewCell!
    @IBOutlet weak var privateTableViewCell: UITableViewCell!
    
    /**
     *  Override 'vie@objc wDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STPrivacyData.swift
         */
        appendData()
    }
    
    
    /**
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STPrivacyNavigationBarController.swift
         */
        appendNavigationBar()
        
        /**
         *  @located in STViewController+Notification.swift
         */
        appendHomeButtonListeners(resignActive: #selector(update), becomeActive: nil)
    }
    
    /**
     *  Override 'viewWillDisappear'.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        update()
        
        /**
         *  @located in STViewController+Notification.swift
         */
        removeHomeButtonListeners()
    }
    
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        /**
         *  @located in STViewController+Notification.swift
         */
        removeHomeButtonListeners()
    }

}
