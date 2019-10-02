//
//  STViewController+Media.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIViewController {
    
    func presentPickerAlertController <D: UINavigationControllerDelegate & UIImagePickerControllerDelegate>(delegate: D, allowsEditing: Bool) {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        let pickerClosure = { [weak self] (sourceType: UIImagePickerControllerSourceType) -> Void in
            guard let strongSelf = self else { return }
            
            if sourceType == .camera && !STDevice.hasCamera { return }
            let mediaTypes = [kUTTypeImage as String]
            if STDevice.allowsMedia(for: sourceType, mandatoryMediaTypes: mediaTypes) == nil { return }
            
            let picker = UIImagePickerController()
            picker.delegate = delegate
            picker.sourceType = sourceType
            picker.allowsEditing = allowsEditing
            picker.mediaTypes = mediaTypes
            strongSelf.present(picker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""),
                                         style: .default, handler: { action in
                                            pickerClosure(.camera)
        })
        alertController.addAction(cameraAction)
        
        let photoLibraryAction = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""),
                                               style: .default, handler: { action in
                                                pickerClosure(.photoLibrary)
                                                
        })
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
