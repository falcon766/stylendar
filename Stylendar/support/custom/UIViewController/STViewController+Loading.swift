//
//  STViewController+Loading.swift
//  Stylendar
//
//  Created by Paul Berg on 22/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    /**
     *  Appends a simple, nice loading view.
     *
     *  Observation: we don't want to add any laoding indicator if a refresh control view is already active.
     */
    func appendLoadingState() {
        if let stylendarViewController = self as? STViewController, let refreshControl = stylendarViewController.refreshControl, refreshControl.isRefreshing { return }
        SVProgressHUD.show()
        (self as? STViewController)?.listView?.isHidden = true
    }
    
    /**
     *  Appends a simple, nice loading view and adds a text on the loading spinner.
     *
     *  Observation: we don't want to add any laoding indicator if a refresh control view is already active.
     */
    func appendLoadingState(text: String) {
        if let stylendarViewController = self as? STViewController, let refreshControl = stylendarViewController.refreshControl, refreshControl.isRefreshing { return }
        SVProgressHUD.show(withStatus: text)
        (self as? STViewController)?.listView?.isHidden = true
    }
    
    /**
     *  Hides the simple, nice loading view.
     */
    func dismissLoadingState() {
        SVProgressHUD.dismiss()
        
        if let stylendarViewController = self as? STViewController {
            stylendarViewController.refreshControl?.endRefreshing()
            stylendarViewController.listView?.isHidden = false
        }
    }
}
