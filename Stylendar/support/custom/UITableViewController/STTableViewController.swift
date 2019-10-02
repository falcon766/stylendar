//
//  STTableViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SVProgressHUD

class STTableViewController: UITableViewController {
    /**
     *  Used to alert the view controller when profile updates were performed.
     */
    weak var delegate: STViewControllerDelegate?
    
    /**
     *  The core list view used to display the data.
     */
    weak var listView: UIScrollView?
    
    /**
     *  It's always better to store a var for an UI element which is currently on screen.
     */
    var progressHUD: SVProgressHUD?
    
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  SVProgressHUD customization.
         */
        SVProgressHUD.setDefaultMaskType(.black)
        
        /**
         *  Basically, we don't want to allow any view controller missing this feature. It's too awesome and util.
         */
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapBackground))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    /**
     *  Called when the background was tapped.
     */
    @objc func didTapBackground() {
        view.endEditing(true)
    }
}
