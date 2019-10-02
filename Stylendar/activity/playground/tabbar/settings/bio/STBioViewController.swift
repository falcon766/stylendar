//
//  STBioViewController.swift
//  AdPacer
//
//  Created by Razvan Paul Birgaoanu on 04/03/2017.
//  Copyright © 2017 VanSoftware. All rights reserved.
//

import UIKit

class STBioViewController: STViewController {
    
    /**
     *  The source of truth for the view controller.
     */
    var data = STBioData()
    
    /**
     *  The core list view used to display the data.
     */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     *  Used to let the user save the new information.
     */
    @IBOutlet weak var saveButton: UIButton!

    /**
     *  Self-explanatory names.
     */
    @IBOutlet weak var profileImageView: UIImageView!
    weak var usernameTextField: UITextField!
    weak var firstNameTextField: UITextField!
    weak var lastNameTextField: UITextField!
    weak var bioTextField: UITextField!
    weak var emailTextField: UITextField!

    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STBioTableViewController.swift
         */
        appendTableView()
        
        
        /**
         *  @located in STBioMediaController.swift
         */
        appendImageView()
    }
    
    
    /**
        Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STBioNavigationBarController.swift
         */
        appendNavigationBar()
    }
    
    /**
     *  Override 'viewDidAppear'.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /**
         *  Focusing on the first text field.
         */
        usernameTextField.becomeFirstResponder()
    }
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
