//
//  STViewController.swift
//  Stylendar
//
//  Created by Paul Berg on 31/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SVProgressHUD

@objc protocol STViewControllerDelegate: class {
    /**
     *  Called when the profile area (from the navigation bar) was tapped.
     */
    @objc optional func didTapProfileArea(_ sender: Any)
    
    /**
     *  Called when the user changed the name through STBioViewController.swift
     */
    func didUpdateName()
    
    /**
     *  Called when the user changed the profile image through STBioViewController.swift
     */
    func didUpdateProfileImage()
}

class STViewController: UIViewController {
    /**
     *  Used to alert the view controller when spefic UX action are triggered.
     */
    weak var delegate: STViewControllerDelegate?
    
    /**
     *  The core list view used to display the data.
     */
    weak var listView: UIScrollView?
    weak var refreshControl: UIRefreshControl?
    
    /**
     *  It's always better to store a var for an UI element which is currently on screen.
     */
    var progressHUD: SVProgressHUD?
    
    /**
     *  Tells if the back button text should be hidden or not.
     */
    var shouldBackButtonTextBeHidden = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
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
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        STGoogle.sendScreen(self)
        
        /**
         *  We always wish to hide the back button text, it's ugly. The last solution (first answer in link below) caused the annoying
         *  UIViewAlertForUnsatisfiableConstraints bug in iOS 11.
         *
         *  Read more: https://stackoverflow.com/questions/19078995/removing-the-title-text-of-an-ios-uibarbuttonitem?page=1&tab=active#tab-top
         */
        if shouldBackButtonTextBeHidden { navigationController?.navigationBar.topItem?.title = "" }
    }
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     *  Called when the background was tapped.
     */
    @objc func didTapBackground() {
        view.endEditing(true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return true }
        if view.isKind(of: UITextField.self) || view.isKind(of: UIButton.self) {
            return false
        }
        return true
    }
}

extension UIViewController {
    /**
     *  Appends the ad pacer logo to the view controller.
     */
    func appendStylendarLogo() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 88, height: 24))
        imageView.image = UIImage(named: "nav_bar_logo")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        navigationItem.titleView = imageView
    }
}
