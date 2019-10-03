//
//  STStylendarNetwork+Image.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 17/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit
import SDWebImage

extension STStylendarViewController {
    /**
     *  When the user successfully captured or chosen an image, we have to upload it.
     */
    func upload(image: UIImage) {
        appendLoadingState()
        guard let authId = Auth.auth().currentUser?.uid else { return }
        guard let uploadData = image.compress(), let path = data.selector.path else {
            STAlert.top(STString.unknownError, isPositive: false)
            return
        }
        
        /**
         *  Read more about this format in STSelector.swift
         */
        let parts = path.components(separatedBy: "/")
        let year = parts[0]
        let month = parts[1]
        let day = parts[2]
        
        let databaseRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.stylendar.node)
            .child(authId)
            .child("y\(year)")
            .child("m\(month)")
        let storageRef =  STStorage
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.stylendar.node)
            .child(authId)
            .child(path + STMedia.format)
        
        let uploadPromise = PromiseKit.wrap{storageRef.putData(uploadData, metadata: nil, completion: $0)}
        
        firstly { () -> Promise<StorageMetadata> in
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
            return uploadPromise
        }.then { (metadata) -> Promise<(Error?, DatabaseReference)> in
            /**
             *  Smartly pre-setting the data and the cache.
             */
            let downloadUrl = metadata.downloadURL()?.absoluteString
            self.data.urls[path] = downloadUrl
            SDImageCache.shared().store(image, forKey: downloadUrl, completion: nil)
            
            let values: [String:String] = [
                "d\(day)": downloadUrl ?? ""
            ]
            return PromiseKit.wrap{databaseRef.updateChildValues(values, withCompletionBlock: $0)}
            }
            /**
             *  Because we firstly upload the image so that we have an url to store, the Realtime Database promise comes after.
             */
            .then { result -> Void in
                self.uploadCompletion(uploadData: uploadData, error: result.0)
            }
            /**
             *  Some nasty stuff happened.
             */
            .catch { error in
                self.dismissLoadingState()
                STError.playground(error)
            }.always {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        }
    }
    
    fileprivate func uploadCompletion(uploadData: Data, error: Error?) {
        dismissLoadingState()
        if let error = error {
            STError.playground(error)
            return
        }
        
        /**
         *   We update the image locally to avoid a data reload.
         */
        guard let _ = data.selector.path, let tableIndexPath = data.selector.tableIndexPath, let collectionIndexPath = data.selector.collectionIndexPath else { return }
        data.selector.clear()
        
        DispatchQueue.global().async {
            let image = UIImage(data: uploadData)
            
            /**
             *  Update the image on the cell on the main thread.
             */
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                if let tableViewCell = strongSelf.tableView.cellForRow(at: tableIndexPath) as? STStylendarTableViewCell {
                    if let collectionViewCell = tableViewCell.collectionView.cellForItem(at: collectionIndexPath) as? STStylendarCollectionViewCell {
                        collectionViewCell.imageView.image = image
                        collectionViewCell.imageView.isHidden = false
                        collectionViewCell.plusImageView.isHidden = true
                    }
                }
            }
        }
        STAlert.top(STString.uploadImageSuccess, isPositive: true)
    }
    
    
    /**
     *  Naturally, an image can also be removed.
     */
    func remove() {
        appendLoadingState()
        guard let authId = Auth.auth().currentUser?.uid else { logout(); return }
        guard let path = data.selector.path else { return }
        
        /**
         *  Read more about this format in STSelector.swift
         */
        let parts = path.components(separatedBy: "/")
        let year = parts[0]
        let month = parts[1]
        let day = parts[2]
        
        let databaseRef = STDatabase
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.stylendar.node)
            .child(authId)
            .child("y\(year)")
            .child("m\(month)")
            .child("d\(day)")
        let storageRef = STStorage
            .shared
            .ref
            .child(STVeins.node)
            .child(STVeins.stylendar.node)
            .child(authId)
            .child(path + STMedia.format)
        
        let downloadURLPromise:Promise<URL>  = PromiseKit.wrap{storageRef.downloadURL(completion: $0)}
        let databasePromise = PromiseKit.wrap{databaseRef.removeValue(completionBlock: $0)}
        let removalPromise = PromiseKit.wrap{storageRef.delete(completion: $0)}
        
        firstly { () -> Promise<URL> in
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = true }
            return downloadURLPromise
        }.then { (url) -> Promise<((Error?, DatabaseReference), Void)> in
            /**
             *  We firstly have to clear the cache of this image.
             *
             *  See more at https://stackoverflow.com/questions/45399586/remove-cache-url-with-sdwebimage-and-firebasestorageui
             */
            SDImageCache.shared().removeImage(forKey: url.absoluteString, withCompletion: nil)
            SDImageCache.shared().removeImage(forKey: url.absoluteString, fromDisk: true, withCompletion: nil)
            
            return when(fulfilled: databasePromise, removalPromise)
            }
            /**
             *  The next step is to proceed with the actual removal from Firebase.
             */
            .then { (results) -> Void in
                self.removeCompletion()
            }
            /**
             *  Some nasty stuff happened.
             */
            .catch { error in
                self.dismissLoadingState()
                STError.playground(error)
            }.always {
                DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
        }
    }
    
    fileprivate func removeCompletion() {
        dismissLoadingState()
        
        guard let path = data.selector.path, let tableIndexPath = data.selector.tableIndexPath, let collectionIndexPath = data.selector.collectionIndexPath else { return }
        /**
         *   We update the image locally to avoid a data reload.
         */
        data.urls[path] = nil
        data.selector.clear()
        
        if let tableViewCell = tableView.cellForRow(at: tableIndexPath) as? STStylendarTableViewCell {
            if let collectionViewCell = tableViewCell.collectionView.cellForItem(at: collectionIndexPath) as? STStylendarCollectionViewCell {
                collectionViewCell.imageView.image = nil
                collectionViewCell.plusImageView.isHidden = false
                collectionViewCell.imageView.isHidden = true
            }
        }
        STAlert.top(STString.removeImageSuccess, isPositive: true)
    }
}
