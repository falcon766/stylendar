//
//  STStylendarMediaController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

private var compression: CGFloat = 0.0
extension STStylendarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     *  The plain, simple UIImagePickerController delegate.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] == nil {
            return
        }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Save photo to PhotosAlbum
            let isSavePhoto = Defaults[.saveToCameraRoll];
            if picker.sourceType == .camera && isSavePhoto {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            checkSizeAndGo(image: image)
        } else {
            STAlert.top(STString.unknownError, isPositive: false)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        data.selector.clear()
        picker.dismiss(animated: true, completion: nil)
    }
}


extension STStylendarViewController {
    func checkSizeAndGo(image: UIImage) {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
            guard let imageSize = image.sizeInBytes(for: STMedia.stylendarJPEGCompression) else {
                STAlert.top(STString.unknownError, isPositive: false)
                return
            }
            
//            if imageSize > Double(STStorage.mb(5)) {
//                compression = STMedia.stylendarJPEGCompression
//            } else {
//                compression = STMedia.stylendarJPEGCompressionSevere
//            }
            
            if imageSize > Double(STStorage.maxSize) {
//                print("\(#function): \(imageSize)")
                STAlert.top(STString.uploadImageSizeError, isPositive: false)
                return
            }
            
            strongSelf.upload(image: image)
        }
    }
}
