//
//  STBioNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 07/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import FirebaseAuth
import PromiseKit

extension STBioViewController {
    
    func sync() {
        guard let user = Auth.auth().currentUser else { return }
        
        /**
         *  Update the Firebase authentication system.
         */
        appendLoadingState()
        
        let ref = STDatabase
            .shared
            .ref
            .child(STUser.node)
            .queryOrdered(byChild: STUser.username)
            .queryEqual(toValue: usernameTextField.text!)
            .queryLimited(toFirst: 1)
        let usernamePromise = PromiseKit.wrap{ref.observeSingleEvent(of: .value, with: $0)}
        
        let request = user.createProfileChangeRequest()
        request.displayName = firstNameTextField.text! + " " + lastNameTextField.text!
        let requestPromise = PromiseKit.wrap{request.commitChanges(completion: $0)}
        
        /**
         *  We always make this promises because they are low bandwidth and, otherwise, we'd really overkill the system. There will basically be too much if statements
         *  otherwise.
         */
        firstly {
            usernamePromise
            }.then { (snapshot) -> Promise<Void> in
                if snapshot.exists() && self.usernameTextField.text! != STUser.shared.username {
                    throw STError.usernameAlreadyExists
                }
                return requestPromise
            }.then { _ -> Void in
                self.syncUser()
            }.catch { (error) in
                self.dismissLoadingState()
                STError.credential(error)
            }
    }
    
    /**
     *  Called if the sync above has successfully occurred.
     */
    func syncUser() {
        let wasNameChanged = firstNameTextField.text! != STUser.shared.name.first || lastNameTextField.text != STUser.shared.name.last
        
        /**
         *  Update the Realtime Database and the cache.
         */
        STUser.shared.username = usernameTextField.text!
        STUser.shared.name.first = firstNameTextField.text!
        STUser.shared.name.last = lastNameTextField.text!
        STUser.shared.name.full = firstNameTextField.text! + " " + lastNameTextField.text!
        STUser.shared.bio = bioTextField.text!
        STUser.shared.update()
        STUser.shared.cache()
        
        /**
         *  We check to see if the name was changed because there's also the possibility that only the username was.
         */
        if wasNameChanged, let tabBarController = tabBarController, let viewControllers = tabBarController.viewControllers {
            for viewController in viewControllers {
                guard let navigationController = viewController as? UINavigationController else { continue }
                if let profileImageDelegate = navigationController.viewControllers.first as? STViewControllerDelegate {
                    profileImageDelegate.didUpdateName()
                }
            }
        }
        
        /**
         *  Alert the user that everything went all right.
         */
        if data.wasImageChanged == false {
            dismissLoadingState()
            STAlert.top(STString.updateProfileSuccess, isPositive: true)
            return
        }
        
        syncImage()
    }
}


extension STBioViewController {
    /**
     *  Upload the image, change the `profileImageUrl` and ping all the STViewControllers which implement the STViewControllerProfileImageDelegate to update the UI.
     */
    func syncImage() {
        guard let uploadData = profileImageView.image!.compress() else {
            STAlert.top(STString.unknownError, isPositive: false)
            return
        }
        
        let imagePromise = PromiseKit.wrap{STStorage
            .shared
            .profileRef
            .putData(uploadData, metadata: nil, completion: $0
            )}
        
        firstly {
            imagePromise
            }.then { (metadata) -> Void in
                guard let profileImageUrl = metadata.downloadURL()?.absoluteString else {
                    throw STError.networkError
                }
                self.syncImageSuccess(profileImageUrl)
            }.catch{ (error) in
                STAlert.top(STString.unknownError, isPositive: false)
            }.always {
                self.dismissLoadingState()
            }
    }
    
    /**
     *  Called if the promise above succeeded.
     */
    func syncImageSuccess(_ profileImageUrl: String) {
        STUser.shared.profileImageUrl = profileImageUrl
        STUser.shared.update()
        
        if let tabBarController = tabBarController, let viewControllers = tabBarController.viewControllers {
            for viewController in viewControllers {
                guard let navigationController = viewController as? UINavigationController else { continue }
                if let profileImageDelegate = navigationController.viewControllers.first as? STViewControllerDelegate {
                    profileImageDelegate.didUpdateProfileImage()
                }
            }
        }
        
        STAlert.top(STString.updateProfileSuccess, isPositive: true)
    }
}
