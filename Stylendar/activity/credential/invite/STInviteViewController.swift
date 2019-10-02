//
//  STInviteViewController.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STInviteViewController: STViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    /**
     *  Used to let the user input the credentials.
     */
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var submitButtonView: UIView!
    
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  Xcode 9 bug. Read more here:
         *
         *  https://stackoverflow.com/questions/45630049/xcode-9-bordercolor-doesnt-work/45630635#45630635
         */
        submitButtonView.layer.borderColor = UIColor.white.cgColor
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
