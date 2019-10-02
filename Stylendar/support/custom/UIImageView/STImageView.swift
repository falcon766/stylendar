//
//  STImageView.swift
//  Stylendar
//
//  Created by Paul Berg on 15/02/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Device
import FirebaseStorage
import SDWebImage

/**
 *  The main closure used to handle the image view custom operations.
 */
public typealias STImageViewOperationCompletion = (Bool) -> Void

private var defaultVelocity: CGFloat = 0.48


extension UIImageView {
    
    /**
     *  Simply loads the image with the specified fade velocity animation.
     */
    func fade(with url: URL) {
        fade(with: url, placeholderImage: nil, errorImage: nil, velocity: defaultVelocity, completion: nil)
    }
    
    func fade(with url: URL, velocity: CGFloat) {
        fade(with: url, placeholderImage: nil, errorImage: nil, velocity: velocity, completion: nil)
    }
    
    func fade(with url: URL, errorImage: UIImage?) {
        fade(with: url, placeholderImage: nil, errorImage: errorImage, velocity: defaultVelocity, completion: nil)
    }
    
    func fade(with url: URL, completion: @escaping STImageViewOperationCompletion) {
        fade(with: url, placeholderImage: nil, errorImage: nil, velocity: defaultVelocity, completion: completion)
    }
    
    func fade(with url: URL, placeholderImage: UIImage, velocity: CGFloat) {
        fade(with: url, placeholderImage: placeholderImage, errorImage: nil, velocity: velocity, completion: nil)
    }
    
    func fade(with url: URL, errorImage: UIImage, velocity: CGFloat) {
        fade(with: url, placeholderImage: nil, errorImage: errorImage, velocity: velocity, completion: nil)
    }
    
    func fade(with url: URL, errorImage: UIImage, completion: @escaping STImageViewOperationCompletion) {
        fade(with: url, placeholderImage: nil, errorImage: errorImage, velocity: defaultVelocity, completion: completion)
    }
    
    func fade(with url: URL, placeholderImage: UIImage?, errorImage: UIImage?, velocity: CGFloat, completion: STImageViewOperationCompletion?) {
        sd_setImage(with: url, placeholderImage: placeholderImage, options: [], completed: { [weak self] (image, error, cacheType, imageUrl) in
            guard let strongSelf = self else { return }
            strongSelf.handleCompletion(errorImage: errorImage, velocity: velocity, completion: completion, image: image, error: error, cacheType: cacheType)
        })
    }
    
    /**
     *  Sugar methods to load the image from Firebase. Because FirebaseStorageUI is complete bullshit when it comes to caching, the system uses only an URL-based infrastructure.
     */
    func fade(using ref: StorageReference) {
        fade(using: ref, placeholderImage: image, errorImage: nil, velocity: defaultVelocity, completion: nil)
    }
    
    func fade(using ref: StorageReference, velocity: CGFloat) {
        fade(using: ref, placeholderImage: nil, errorImage: nil, velocity: velocity, completion: nil)
    }
    
    func fade(using ref: StorageReference, errorImage: UIImage) {
        fade(using: ref, placeholderImage: nil, errorImage: errorImage, velocity: defaultVelocity, completion: nil)
    }
    
    func fade(using ref: StorageReference, completion: @escaping STImageViewOperationCompletion) {
        fade(using: ref, placeholderImage: nil, errorImage: nil, velocity: defaultVelocity, completion: completion)
    }
    
    
    func fade(using ref: StorageReference, placeholderImage: UIImage, velocity: CGFloat) {
        fade(using: ref, placeholderImage: placeholderImage, errorImage: nil, velocity: velocity, completion: nil)
    }
    
    func fade(using ref: StorageReference, errorImage: UIImage, velocity: CGFloat) {
        fade(using: ref, placeholderImage: nil, errorImage: errorImage, velocity: velocity, completion: nil)
    }
    
    func fade(using ref: StorageReference, errorImage: UIImage, completion: @escaping STImageViewOperationCompletion) {
        fade(using: ref, placeholderImage: nil, errorImage: errorImage, velocity: defaultVelocity, completion: completion)
    }
    
    func fade(using ref: StorageReference, placeholderImage: UIImage?, errorImage: UIImage?, velocity: CGFloat, completion: STImageViewOperationCompletion?) {
        ref.downloadURL { [weak self] (url, error) in
            guard let strongSelf = self else { return }
            
            /**
             *  If either the `url` is missing or the error is nil, Houston we have a problem.
             */
            guard let url = url, case nil = error else {
                if let errorImage = errorImage {
                    strongSelf.image = errorImage
                    strongSelf.fade(for: CFTimeInterval(velocity))
                }
                completion?(false)
                return
            }
            
            /**
             *  Good to go!
             */
            strongSelf.fade(with: url, placeholderImage: placeholderImage, errorImage: errorImage, velocity: defaultVelocity, completion: completion)
        }
    }
    
    /**
     *  DRY is life.
     */
    fileprivate func handleCompletion(errorImage: UIImage?, velocity: CGFloat, completion: STImageViewOperationCompletion?, image: UIImage?, error: Error?, cacheType: SDImageCacheType) {
        /**
         *  If the image didn't return or there's an error,
         */
        let failureClosure = { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            print("\(#function): \(error?.localizedDescription ?? "error is nil")")
            
            if let errorImage = errorImage {
                strongSelf.image = errorImage
                strongSelf.fade(for: CFTimeInterval(velocity))
            }
            completion?(false)
        }
        
        /**
         *  If the image is nil or there's an error, we have to show the error image.
         */
        if image == nil || error != nil {
            failureClosure()
            return
        }
        
        /**
         *  Or if the cache has already this image stored, then we don't have to animate anything.
         */
        defer {
            completion?(true)
        }
        guard cacheType == .none else {
            return
        }
        fade(for: CFTimeInterval(velocity))
    }
}

