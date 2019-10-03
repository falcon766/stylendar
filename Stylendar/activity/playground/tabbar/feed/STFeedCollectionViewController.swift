//
//  STFeedCollectionViewController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 11/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Firebase

extension STFeedViewController {
    /**
     *  Appends the configured collection view to the view controller.
     */
    func appendCollectionView() {
        /**
         *  Registering the cells on the table view.
         */
        collectionView.register(UINib(nibName: String(describing: STFeedHeaderView.self), bundle: .main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(UINib(nibName: String(describing: STFeedCollectionViewCell.self), bundle: .main), forCellWithReuseIdentifier: "cell")
        
        /**
         *  The no data configurations.
         */
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        /**
         *  Other configurations.
         */
        collectionView.addSubview(refreshControlView)
    }
    
    /**
     *  The the refresh control view was dragged.
     */
    @objc func didDragRefreshControlView(_ sender: Any) {
        reload()
    }
}

/**
 *  The collection view data source.
 */
extension STFeedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        assert(kind == UICollectionElementKindSectionHeader, "Unexpected element kind: \(kind)")
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerView", for: indexPath) as? STFeedHeaderView else {
            return UICollectionReusableView()
        }
        
        /**
         *  We perform the operations in the background cuz we want to have the rendering as smooth as possible.
         */
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            let americanized = STDate.americanize(strongSelf.data.dates[indexPath.section])
            
            DispatchQueue.main.async {
                headerView.dateLabel.text = americanized
            }
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let date = data.dates[section]
        guard let length = data.posts[date]?.count else { return 0 }
        return length
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? STFeedCollectionViewCell else { return UICollectionViewCell() }
        
        /**
         *  Get the data item.
         */
        let date = data.dates[indexPath.section]
        guard let post = data.posts[date]?[indexPath.row] else {
            return cell
        }
        
        /**
         *  Set it on the cell.
         */
        cell.usernameLabel.text = post.sender.username?.uppercased()

        if let profileImageUrlString = post.sender.profileImageUrl, let profileImageUrl = URL(string: profileImageUrlString) {
            cell.profileImageView.fade(with: profileImageUrl, completion: { (success) in })
        } else {
            cell.profileImageView.image = nil
        }
        
        if let imageUrlString = post.imageUrl, let imageUrl = URL(string: imageUrlString) {
            cell.postImageView.fade(with: imageUrl, completion: { (success) in })
        } else {
            cell.postImageView.image = nil
        }
        
        return cell
    }
}

/**
 *  The collection view delegate.
 */
extension STFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    
        /**
         *  Get the data item.
         */
        let date = data.dates[indexPath.section]
        guard let post = data.posts[date]?[indexPath.row] else { return }

        /**
         *  Redirect to the user's own Stylendar is this is the case.
         */
        if post.sender.uid == Auth.auth().currentUser?.uid {
            tabBarController?.selectedIndex = 0
            return
        }
        
        /**
         *  Go the single post view.
         */
        let storyboard = UIStoryboard(name: String(describing: STPostSingleViewController.self), bundle: Bundle.main)
        guard let postViewController = storyboard.instantiateInitialViewController() as? STPostSingleViewController else { return }
        postViewController.data = STPostSingleData(user: post.sender, postImageUrl: post.imageUrl, date: date)
        navigationController?.pushViewController(postViewController, animated: true)
    }
}

/**
 *  The collection view flow delegate.
 */
extension STFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: STDevice.width, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (STDevice.width - 18) / 2
        return CGSize(width: width, height: width * 5 / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}


/**
 *  The empty data set and delegate.
 */
extension STFeedViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !pagination.isBusy
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "ic_cancel")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .main
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSAttributedStringKey.font: UIFont.montserrat(size: 13),
                          NSAttributedStringKey.foregroundColor: UIColor.white]
        
        return NSAttributedString(string: NSLocalizedString("Sadly, you don't have any posts in your feed", comment: ""),
                                  attributes: attributes)
    }
}
