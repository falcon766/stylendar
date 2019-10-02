//
//  STLoginViewController.swift
//  Stylendar
//
//  Created by Paul Berg on 16/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STLoginViewController: STViewController {

    /**
     *  The views which let the user type the email and the password.
     */
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var firstTime: Bool = true
    
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
         *  @located in STLoginNavigationBarController.swift
         */
        appendNavigationBar()
    }
    
    /**
     *  Override 'viewDidAppear'.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        /**
         *  We make the email the first responder only the first time the screen is instantiated.
         */
        if firstTime {
            firstTime = false
            emailTextField.becomeFirstResponder();
        }
    }
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
