//
//  STForgotPasswordViewController.swift
//  Stylendar
//
//  Created by Paul Berg on 25/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STForgotPasswordViewController: STViewController {
    
    /**
        The text field used to let the user type the email.
     */
    @IBOutlet weak var emailTextField: UITextField!
    
    /**
        Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    /**
        Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STForgotPasswordNavigationBarController.swift
         */
        appendNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
   
    /**
        Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
