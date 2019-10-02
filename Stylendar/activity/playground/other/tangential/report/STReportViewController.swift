//
//  STReportViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 24/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STReportViewController: STViewController {
    /**
     *  The source of truth for the view controller.
     */
    var data = STReportData()
    
    /**
     *  The views.
     */
    @IBOutlet weak var reasonTextView: UITextView!
    
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
         *  @localized in STReportNavigationBarController.swift
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
        reasonTextView.becomeFirstResponder()
    }
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
