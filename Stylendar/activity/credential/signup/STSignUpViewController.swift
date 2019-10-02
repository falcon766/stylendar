//
//  STSignUpViewController.swift
//  Stylendar
//
//  Created by Paul Berg on 18/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import ZSWSuffixTextView

class STSignUpViewController: STViewController {
    
    /**
     *  The source of truth for this view controller.
     */
    var data = STSignUpData()
    
    /**
     *  The IBOutlets. Connect the Interface Builder to the swift view controller.
     */
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var bioTextView: ZSWSuffixTextView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    /**
     *  The icons.
     */
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var emailImageView: UIImageView!
    @IBOutlet weak var firstNameImageView: UIImageView!
    @IBOutlet weak var lastNameImageView: UIImageView!
    @IBOutlet weak var bioImageView: UIImageView!
    
    /**
        Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in @STSignUpMediaController.swift
         */
        appendImageView()
    }

    /**
        Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STSignUpNavigationBarController.swift
         */
        appendNavigationBar()
    }
    
    
    /**
        Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
