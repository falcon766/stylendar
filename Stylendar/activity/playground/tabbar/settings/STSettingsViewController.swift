//
//  STSettingsViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 29/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STSettingsViewController: STTableViewController {
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
         *  @located in STSettingsNavigationBarController.swift
         */
        appendNavigationBarButton()
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

