//
//  STOnboardingViewController.swift
//  Stylendar
//
//  Created by Paul Berg on 23/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STOnboardingViewController: STViewController {
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /**
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STOnboardingNavigationBarController.swift
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
