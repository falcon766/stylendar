//
//  STReportNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 24/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Firebase
import PromiseKit

extension STReportViewController {
    
    /**
     *  Submits the report in the database, if all of the conditions are met.
     */
    func submit() {
        guard let selfUid = Auth.auth().currentUser?.uid else { return }
        
        /**
         *  Create the ref, the query and the promise.
         */
        let queryUid = "\(selfUid)_\(data.user.uid!)"
        var reusableRef = STDatabase
            .shared
            .ref
            .child(STAdmin.node)
            .child(STAdmin.report.node)
        let query = reusableRef
            .queryOrdered(byChild: STAdmin.report.queryUid)
            .queryEqual(toValue: queryUid)

        let promise = PromiseKit.wrap{query.observeSingleEvent(of: .value, with: $0)}
        
        /**
         *  Kickstart the promise system.
         */
        firstly {
                promise
            }.then { (snapshot) -> Promise<(Error?, DatabaseReference)> in
                guard !snapshot.exists() else { throw STError.reportSubmittedAlready }
                
                reusableRef = reusableRef.childByAutoId()
                let user: [String:Any] = [
                    STUser.uid: self.data.user.uid,
                    STUser.name.node: self.data.user.name,
                    STUser.username: self.data.user.username ?? "",
                    STUser.profileImageUrl: self.data.user.profileImageUrl ?? ""
                ]
                let update: [String:Any] = [
                    STAdmin.report.senderUid: selfUid,
                    STAdmin.report.reportedUid: self.data.user.uid,
                    STAdmin.report.queryUid: queryUid,
                    STAdmin.report.reason: self.reasonTextView.text!,
                    STAdmin.report.user: user
                ]
                let promise = PromiseKit.wrap{reusableRef.updateChildValues(update, withCompletionBlock: $0)}
                return promise
            }.then { (result) -> Void in
                self.success()
        }.catch{ (error) in
                self.failure(error)
        }
    }
    
    /**
     *  Called if the request above failed.
     */
    fileprivate func success() {
        let title = NSLocalizedString("Done", comment: "")
        let message = NSLocalizedString("You've successfully reported the user. Thanks so much!", comment: "")
        STAlert.center(title: title, message: message, handler: { [weak self] (action) in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.popViewController(animated: true)
        })
    }
    
    /**
     *  Called if the request above succeeded.
     */
    fileprivate func failure(_ error: Error) {
        if error.code == STError.reportSubmittedAlreadyCode {
            STAlert.center(title: STString.oops, message: STString.reportSubmittedAlready, handler: { [weak self] (action) in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.popViewController(animated: true)
            })
        } else {
            STError.playground(error)
        }
    }
}
