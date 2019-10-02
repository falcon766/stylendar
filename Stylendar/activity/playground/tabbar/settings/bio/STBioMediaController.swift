//
//  STBioMediaController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STBioViewController {
    /**
     *  Appends the configured image views to the view controller.
     */
    func appendImageView() {
        guard let profileImageUrl = STUser.shared.profileImageUrl, let url = URL(string: profileImageUrl) else { return }
        profileImageView.fade(with: url)
    }
    
    /**
     *  Called when the profile image super view was tapped.
     */
    @IBAction func didTapProfileImageSuperView(_ sender: Any) {
        presentPickerAlertController(delegate: self, allowsEditing: true)
    }
}

extension STBioViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     *  The plain, simple UIImagePickerController delegate.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if info[UIImagePickerControllerOriginalImage] == nil {
            return
        }
        
        data.wasImageChanged = true
        profileImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
