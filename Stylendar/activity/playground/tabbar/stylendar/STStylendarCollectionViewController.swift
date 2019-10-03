//
//  STStylendarCollectionViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 27/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth
import LKAlertController
import SDWebImage

extension STStylendarViewController: UICollectionViewDataSource {
    
    /**
     *  The collection view are unitary-sectioned. We'd really overkill this page otherwise.
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
 
    /**
     *  Usually, this will be 7, but there is one exception.
     *
     *  - If this is the last row of the Stylendar. (there is a high chance that Saturday is not the last day).
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tableIndexPath = collectionView.tableIndexPath
        
        let isEndingRow = tableIndexPath.row == (tableView.numberOfRows(inSection: 0) - 1)
        if isEndingRow {
            return data.selector.totalDays %% 7
        }
        
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? STStylendarCollectionViewCell else { return STStylendarCollectionViewCell() }
        let tableIndexPath = collectionView.tableIndexPath
        let index = (tableIndexPath.row * 7) + indexPath.row
        
        /**
         *  If this is the first month, we have to make sure we don't display any cell before the first day.
         */
        
        cell.contentView.isHidden = false
        cell.indexPath = indexPath
        cell.delegate = self
        
        /**
         *  Set the day label.
         */
        cell.dayLabel.text = data.selector.holder.printables[index]
        /**
         *  If the current cell represents the today's polaroid, we highlight it with the navy blue from the palette.
         */
        guard let path = data.selector.holder.paths[index] else { return cell }
        cell.dayLabel.textColor = data.selector.todayIndex != index ? .appGray : .main
        cell.labelView.backgroundColor = data.selector.todayIndex != index ? .main : .appGray
        cell.imageContainerView.backgroundColor = data.selector.todayIndex != index ? .main : .appGray
        cell.lineView.backgroundColor = data.selector.todayIndex != index ? .appGray : .main
        cell.plusImageView.image = data.selector.todayIndex != index ? UIImage(named: "logo-white") : UIImage(named: "logo-blue")
        /**
         *  Set the image view.
         */
        if let urlString = self.data.urls[path], let url = URL(string: urlString) {
            cell.plusImageView.isHidden = true
            cell.imageView.isHidden = false
            cell.imageView.fade(with: url, completion: { (success) in })
        } else {
            cell.imageView.image = nil
            cell.plusImageView.isHidden = false
            cell.imageView.isHidden = true
        }
        
        return cell
    }
}

extension STStylendarViewController: UICollectionViewDelegate, STStylendarCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        /**
         * If the frequency array returns nil for the given dayOfMonth, it means the system didn't even fulfill the initial request to get the image.
         */
        let index = (collectionView.tableIndexPath.row * 7) + indexPath.row
        guard let path = data.selector.holder.paths[index] else { return }
        
        /**
         *  If no image exists for this day of month, we wish to let the user upload one.
         */
        guard let _ = data.urls[path] else {
            /**
             *  A global stylendar cannot be modified by this user.
             */
            guard state == .personal else { return }
            data.selector.append(tableIndexPath: collectionView.tableIndexPath, collectionIndexPath: indexPath, path: path)
            presentPickerAlertController(delegate: self, allowsEditing: false)
            return
        }
        
        
        /**
         *  Otherwise, if the image already exists, redirect the user to the post page.
         */
        let storyboard = UIStoryboard(name: String(describing: STPostMultipleViewController.self), bundle: .main)
        guard let postViewController = storyboard.instantiateInitialViewController() as? STPostMultipleViewController else { return }
        
        postViewController.postDelegate = self
        data.selector.append(tableIndexPath: collectionView.tableIndexPath, collectionIndexPath: indexPath, path: path)
        postViewController.data = STPostMultipleData(user: state == .personal ? STUser.shared : data.user, selector: data.selector, urls: data.urls, selected: index)
        
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    
    func collectionView(collectionView: UICollectionView, didLongTapItemAt indexPath: IndexPath) {
        let tableIndexPath = collectionView.tableIndexPath
        let index = (tableIndexPath.row * 7) + indexPath.row
        
        guard
            let path = data.selector.holder.paths[index],
            let _ = data.urls[path]
        else { return }
        data.selector.tableIndexPath = tableIndexPath
        data.selector.collectionIndexPath = indexPath
        data.selector.path = path

        ActionSheet()
            .addAction(NSLocalizedString("Remove", comment: ""), style: .destructive, handler: { [weak self] (action) in
                guard let strongSelf = self else { return }
                strongSelf.remove()
            })
            .addAction(STString.cancel, style: .cancel)
            .show(animated: true)
    }
    
}


extension STStylendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 6)
    }
}
