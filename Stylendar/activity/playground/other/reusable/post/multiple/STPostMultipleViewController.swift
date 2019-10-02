//
//  STPostMultipleViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 31/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import iCarousel

protocol STPostMultipleViewControllerDelegate: class {
    func didTapRemoveButton()
}

class STPostMultipleViewController: STViewController {
    
    /**
     *  Announcs the sender class that the user wants to delete the post.
     */
    weak var postDelegate: STPostMultipleViewControllerDelegate?
    
    /**
     *  The source of truth for the view controller.
     */
    var data = STPostMultipleData()
    
    @IBOutlet weak var profileView: STProfileView!
    @IBOutlet weak var carousel: iCarousel!

    
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STPostMultipleCarouselController.swift
         */
        appendCarousel()
        
        /**
         *  @located in STPostMultipleData.swift
         */
        startup()
    }
    
    /**
     *  Override 'viewWillAppear'.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /**
         *  @located in STPostMultipleNavigationBarController.swift
         */
        appendNavigationBar()
    }
    
    /**
     *  Override 'didReceiveMemoryWarning'.
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
