//
//  STDatabase.swift
//  Stylendar
//
//  Created by Paul Berg on 19/01/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import PromiseKit
import SwiftDate
import SwiftyUserDefaults
import SwiftyJSON

/**
 *  The main database closure used to handle the Firebase reads & writes.
 */
typealias STDatabaseCompletion = (Error?) -> Void

/**
 *  Highly important enum. Defines the state, which tells what is currently happening on the database.
 */
@objc enum STDatabaseState: Int {
    case still = 1,
    active = 2
}

class STDatabase: NSObject {
    /**
     *  Can't init, this is a singleton class.
     */
    private override init() { }
    
    /**
     *  The method which creates the Firebase database singleton.
     */
    static let shared: STDatabase = STDatabase()
    
    /**
     *  Tells what is currently happening on the database.
     */
    @objc dynamic var state: STDatabaseState = .still
    
    /**
     *  The reference to the Firebase database.
     */
    var ref: DatabaseReference {
        get {
            return Database.database().reference()
        }
    }
}


extension STDatabase {
    /**
     *  Preinsert an user in the database by invitation. This means the account will be on hold until an activation link is sent on the email.
     */
    func preinsertUser(firstName: String, lastName: String, email: String, completion: STDatabaseCompletion?) {
        guard firstName.isValid && lastName.isValid && email.isValid else {
            completion?(STError.inviteFormat)
            return
        }
        
        STDatabase
            .shared
            .ref
            .child(STUser.invitation.node)
            .queryEqual(toValue: email, childKey: STUser.invitation.email)
            .queryLimited(toFirst: 1)
            .observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.exists() {
                    completion?(STError.inviteSubmittedAlready)
                    return
                }
                
                /**
                 *  Otherwise, simply insert it into the database.
                 */
                /**
                 *  We're building the JSON to be sent to Firebase.
                 */
                let name: [String:String] = [STUser.invitation.name.full: String(format: "%@ %@", firstName, lastName),
                                             STUser.invitation.name.first: firstName,
                                             STUser.invitation.name.last: lastName
                ]
                
                /**
                 *  In the hindsight of the invite form submission, the `delivered` state will be set to `false` because this tells whether or not the invitation email was sent to
                 *  the corresponding person by email.
                 */
                let invitation: [String:Any] = [STUser.invitation.email: email,
                                                STUser.invitation.name.node: name,
                                                STUser.invitation.deliver: false
                                          ]
                
                /**
                 *  Finally make the Firebase call to register the new user.
                 */
                STDatabase
                    .shared
                    .ref
                    .child(STUser.invitation.node)
                    .childByAutoId()
                    .updateChildValues(invitation, withCompletionBlock: { error, ref in
                        completion?(error as Error?)
                        print("@preinsertUser: was successful? ", error == nil)
                    })
                
            })  { error in
                completion?(error as Error?)
        }
    }
    
    /**
     *  Inserts an user in the database. We only need the 'firstName' and the 'lastName' because the other data is stored in the authenticated users panel.
     */
    func insertUser(authId: String, username: String, firstName: String, lastName: String, email: String, bio: String?, image: UIImage, completion: STDatabaseCompletion?) {
        /**
         *  We're building the JSON to be sent to Firebase. We're using setValue because we're inserting a new fresh user here.
         */
        let fcm_token = InstanceID.instanceID().token()
        let utc_offset = NSNumber(value: Float(TimeZone.current.secondsFromGMT()) / 3600.0)
        
        let name: [String:String] = [STUser.name.full: firstName + " " + lastName,
                                     STUser.name.first: firstName,
                                     STUser.name.last: lastName
        ]
        let bio = bio ?? NSLocalizedString("Hi! I'm using Stylendar.", comment: "") // fallback to default description
        let createdAt = Date().inGMTRegion().string(format: .iso8601Auto)
        let notifications: [String:Any] = [STUser.notifications.enabled: true
        ]
        let privacy: [String:Any] = [STUser.privacy.isStylendarPublic: true
        ]
        
        var user: [String:Any] = [STUser.name.node: name,
                                  STUser.email: email,
                                  STUser.username: username,
                                  STUser.profileImageUrl: "",
                                  STUser.bio: bio,
                                  STUser.createdAt: createdAt,
                                  STUser.fcmToken: fcm_token ?? "",
                                  STUser.utcOffset: utc_offset,
                                  STUser.notifications.node: notifications,
                                  STUser.privacy.node: privacy
        ]
        
        
        /**
         *  Make the Firebase call to register the new user.
         */
        guard let uploadData = image.compress() else {
            completion?(STError.uploadImageData)
            return
        }
        let imagePromise = PromiseKit.wrap{STStorage
            .shared
            .profileRef
            .putData(uploadData, metadata: nil, completion: $0
        )}
        let databaseRef = STDatabase
            .shared
            .ref
            .child(STUser.node)
            .child(authId)

        imagePromise.then{ (metadata) -> Promise<(Error?, DatabaseReference)>  in
            user[STUser.profileImageUrl] = metadata.downloadURL()?.absoluteString ?? ""
            return PromiseKit.wrap{databaseRef.updateChildValues(user, withCompletionBlock: $0)}
        }
        .then{ (result) -> Void in
            if let error = result.0 {
                completion?(error)
                print("\(#function): successful")
                return
            }
            
            completion?(nil)
        }
        .catch { error in
                completion?(error)
                print("\(#function): unsuccessful")
        }
    }
}


extension STDatabase {
    
    /**
     *  Updates a user from the database.
     */
    func updateUser() {
        /**
         *  We basically can't do anything without the user logged in.
         */
        guard let authId = Auth.auth().currentUser?.uid, let _ = STUser.shared.email else { return }
        
        /**
         *  We're building the JSON to be sent to Firebase.
         */
        let fcm_token = InstanceID.instanceID().token()
        let utc_offset = NSNumber(value: Float(TimeZone.current.secondsFromGMT()) / 3600.0)
        
        let name: [String:String] = [STUser.name.full: STUser.shared.name.full ?? "",
                                     STUser.name.first: STUser.shared.name.first ?? "",
                                     STUser.name.last: STUser.shared.name.last ?? ""
        ]
        let notifications: [String:Any] = [STUser.notifications.enabled: STUser.shared.notifications.enabled
        ]
        let privacy: [String:Any] = [STUser.privacy.isStylendarPublic: STUser.shared.privacy.isStylendarPublic
        ]
        let user: [String:Any] = [STUser.name.node: name,
                                  STUser.email: STUser.shared.email ?? "",
                                  STUser.username: STUser.shared.username ?? "",
                                  STUser.profileImageUrl: STUser.shared.profileImageUrl ?? "",
                                  STUser.bio: STUser.shared.bio ?? "",
                                  STUser.createdAt: STUser.shared.createdAt ?? "",
                                  STUser.fcmToken: fcm_token ?? "",
                                  STUser.utcOffset: utc_offset,
                                  STUser.notifications.node: notifications,
                                  STUser.privacy.node: privacy
        ]
        let update = ["/\(STUser.node)/\(authId)": user]
        
        
        /**
         *  Finally, make the Firebase call to update the user.
         */
        STDatabase
            .shared
            .ref
            .updateChildValues(update, withCompletionBlock: {error, ref in
                print("\(#function): was successful? ", error == nil)
            })
    }
    
    /**
     *  This is called everytime the app goes into background to ensure Firebase has the latest values (which are continously changing).
     */
    func updateUserEssentials() {
        guard let authId = Auth.auth().currentUser?.uid, let _ = STUser.shared.email else { return }
        
        /**
         *  We're building the JSON to be sent to Firebase.
         */
        let fcm_token = InstanceID.instanceID().token() ?? ""
        let utc_offset = NSNumber(value: Float(TimeZone.current.secondsFromGMT()) / 3600.0)

        let ref = STDatabase
            .shared
            .ref
            .child(STUser.node)
            .child(authId)
        let fcmTokenPromise = PromiseKit.wrap{ ref
            .updateChildValues([STUser.fcmToken: fcm_token], withCompletionBlock: $0)
        }
        
        let utcOffsetPromise = PromiseKit.wrap{ ref
            .updateChildValues([STUser.utcOffset: utc_offset], withCompletionBlock: $0)
        }
        /**
         *  Finally, make the Firebase call to update the user.
         */
        firstly {
            when(fulfilled: fcmTokenPromise, utcOffsetPromise)
            }.then { (results) -> Void in
                print("\(#function): was successful")
            }.catch { (error) -> Void in
                print("\(#function): was NOT successful")
            }
    }
}


extension STDatabase {
    /**
     *  Retrieves the user from Firebase each time the app is instantiated. The goal is to have a synchronised version of the user throughout the app to not be forced to always
     *  retrieve it. EG: notifications customization page.
     */
    func retrieveUser() {
        guard let authId = Auth.auth().currentUser?.uid else { return }
        
        state = .active
        STDatabase
            .shared
            .ref
            .child(STUser.node)
            .child(authId)
            .observeSingleEvent(of: .value, with: { [unowned self] snapshot in
                if let dictionary = snapshot.value as? [String:AnyObject], snapshot.exists() {
                    STUser.shared.parse(dictionary)
                    return
                }
                self.state = .still
                print("@retrieveUser: snapshot doesn't exist.")
        }) { [unowned self] error in
            self.state = .still
            print(error.localizedDescription)
        }
    }

    func retrieveNewData() -> Promise<Void> {
        return Promise<Void>{ (resolve, reject) in
            guard let authId = Auth.auth().currentUser?.uid else {
                let error = NSError()
                return reject(error)
            }

            state = .active
            STDatabase
                .shared
                .ref
                .child(STUser.node)
                .child(authId)
                .observeSingleEvent(of: .value, with: { [unowned self] snapshot in
                    if let dictionary = snapshot.value as? [String:AnyObject], snapshot.exists() {
                        STUser.shared.parse(dictionary)
                        resolve(())
                        return
                    }
                    self.state = .still
                    reject(NSError(domain: "snapshot doesn't exist.", code: 999, userInfo: nil))
                    print("@retrieveUser: snapshot doesn't exist.")
            }) { [unowned self] error in
                self.state = .still
                reject(error)
                print(error.localizedDescription)
            }
        }
    }
}



