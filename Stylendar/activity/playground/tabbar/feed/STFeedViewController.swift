//
//  STFeedViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 29/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
let STYLENDAR_CELL_WIDTH: CGFloat = 96
let STYLENDAR_CELL_HEIGHT: CGFloat = 168
class STFeedViewController: STViewController {
    
    /**
     *  The source of truth for the table view and for the view controller itself.
     */
    var data = STFeedData()
    
    /**
     *  The core list view used to display the data.
     */
    @IBOutlet weak var collectionView: UICollectionView!
    
    /**
     *  Used to refresh the data on the view controller.
     */
    lazy var refreshControlView: UIRefreshControl = {
        let refreshControlView = UIRefreshControl()
        refreshControlView.addTarget(self, action: #selector(self.didDragRefreshControlView(_:)), for: .valueChanged)
        refreshControlView.tintColor = .white
        return refreshControlView
    }()
    
    
    /**
     *  Override 'viewDidLoad'.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
         *  @located in STViewController.swift
         */
        delegate = self
        
        /**
         *  We're appending an activity indicator view only the first time this view controller is loaded.
         */
        listView = collectionView
        refreshControl = refreshControlView
        appendLoadingState()
        
        /**
         *  @located in STStylendarNavigationBarController.swift
         */
        appendNavigationBarButton()
        
        /**
         *  @located in STFeedCollectionViewController.swift
         */
        appendCollectionView()
        
        /**
         *  @located in STFeedData.swift
         */
        appendPaginationData()
        
        /**
         *  @located in STFeedNetwork.swift
         */
        retrievePosts()
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
