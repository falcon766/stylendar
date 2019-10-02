//
//  STEmailVerificationViewController.swift
//  Stylendar
//
//  Created by Paul Berg on 23/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

/**
    This view controller is opened both in the credential and the playground environments. That's why we created a state for it.
 */
enum STEmailVerificationViewControllerState: Int {
    case signup = 1,
    editProfile = 2
}

class STEmailVerificationViewController : STViewController {
    
    /**
        Highly important variable. Tells the state of the view controller.
     */
    var state: STEmailVerificationViewControllerState = .signup
    
    /**
        The button which is in the center of the page and let's the user either check his email or going back.
     */
    @IBOutlet weak var centerButton: UIButton!
    
    /**
        Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
            @located in STEmailVerificationButtonController.swift
         */
        appendButton()
    }
    
    
    /**
        Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STEmailVerificationNavigationBarController.swift
         */
        appendNavigationBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.checkEmailVerificationState),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object:  nil)
    }
    
    /**
        Override 'viewWillDisappear'.
     */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                  object:  nil)
    }
    
    
    /**
        Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
        Override 'deinit'.
     */
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                  object:  nil)
    }
}
