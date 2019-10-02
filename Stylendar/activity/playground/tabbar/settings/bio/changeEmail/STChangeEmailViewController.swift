//
//  STChangeEmailViewController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

class STChangeEmailViewController: STViewController {
    
    /**
        The core list view used to display the data.
     */
    @IBOutlet weak var tableView: UITableView!
    
    /**
        Used to let the user save the new information.
     */
    @IBOutlet weak var saveButton: UIButton!
    
    /**
        Self-explanatory names.
     */
    weak var passwordTextField: UITextField!
    weak var emailTextField: UITextField!
    
    
    /**
        Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
            @located in STChangeEmailTableViewController.swift
         */
        appendTableView()
    }
    
    
    /**
        Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
            @located in STChangeEmailNavigationBarController.swift
         */
        appendNavigationBar()
    }
    
    
    /**
        Override 'viewDidAppear'.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        passwordTextField.becomeFirstResponder()
    }
    
    
    /**
        Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
