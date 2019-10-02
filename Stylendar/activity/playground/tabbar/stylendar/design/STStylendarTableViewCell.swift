//
//  STStylendarTableViewCell.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STStylendarTableViewCell: STTableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    /**
     *  Sugar methods to simply connect the table vieW cell's collection view.
     */
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate> (dataSourceDelegate: D, forIndexPath indexPath: IndexPath) {
        if collectionView.dataSource == nil {
            collectionView.dataSource = dataSourceDelegate
            collectionView.delegate = dataSourceDelegate
            collectionView.register(UINib(nibName: String(describing: STStylendarCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        }
        
        /**
         *  Because the cells are reused, the tags are also reused. We have to make sure each collection view keeps its ordinal number. We reload the data so the cells which
         *  have to be hidden will be (adjustment cells).
         */
        if collectionView.tableIndexPath != indexPath {
            collectionView.tableIndexPath = indexPath
            collectionView.reloadData()
        }
    }
}


extension STStylendarTableViewCell {
    func setCollectionViewLongTapGestureRecognizer() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handle(gestureRecognizer:)))
        lpgr.delegate = self
        collectionView.addGestureRecognizer(lpgr)
    }
    
    /**
     *  When the UI calls this function, the table view cell redirects the task to the view controller. There, we can make the transition to the post page.
     */
    @objc func handle(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .began {
            return
        }
        let point = gestureRecognizer.location(in: self.collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: point) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? STStylendarCollectionViewCell else { return }
        
        cell.delegate?.collectionView(collectionView: collectionView, didLongTapItemAt: indexPath)
    }
}
