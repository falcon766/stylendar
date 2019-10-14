//
//  STProfileButtonController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STProfileViewController {
    
    /**
     *  Called when the flag bar button item (top right) was tapped.
     */
    @objc func didTapFlagBarButtonItem() {
        switch displayMode {
        case .otherPeople:
            showSTReportViewController()
        case .mySelf:
            showSTBioViewController()
        }
    }
    
    private func showSTBioViewController(){
        goto(viewController: STBioViewController.self)
    }
        
    
    private func showSTReportViewController()  {
        let storyboard = UIStoryboard(name: String(describing: STReportViewController.self), bundle: .main)
        guard let reportViewController = storyboard.instantiateInitialViewController() as? STReportViewController else { return }
        reportViewController.data.user = data.user
        show(reportViewController, sender: self)
    }
}
