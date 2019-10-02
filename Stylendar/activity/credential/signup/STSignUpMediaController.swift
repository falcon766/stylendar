//
//  STSignUpMediaController.swift
//  Stylendar
//
//  Created by Paul Berg on 25/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STSignUpViewController {
    
    /**
     *  Appends the configured image to the view controller.
     */
    func appendImageView() {
        cameraImageView.tintColor = .iconGray
        emailImageView.tintColor = .iconGray
        firstNameImageView.tintColor = .iconGray
        lastNameImageView.tintColor = .iconGray
        bioImageView.tintColor = .iconGray
    }
    
    /**
     *  Called when the profile image super view was tapped.
     */
    @IBAction func didTapProfileImageSuperView(_ sender: Any) {
        presentPickerAlertController(delegate: self, allowsEditing: true)
    }
}

extension STSignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     *  The plain, simple UIImagePickerController delegate.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] == nil {
            return
        }

        profileImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
