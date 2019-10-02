//
//  STStylendarObserverController.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 30/07/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

extension STStylendarViewController {
    /**
     *  The key-value observer.
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if let _ = object as? STDatabase {
            /**
             *  Basically, this observer should be stopped when the database's state has changed to `still`.
             */
            if STDatabase.shared.state == .still {
                startup()
                STDatabase.shared.removeObserver(self, forKeyPath: #keyPath(STDatabase.state))
            }
        }
    }
}
