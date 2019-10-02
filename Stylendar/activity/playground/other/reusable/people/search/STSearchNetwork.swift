//
//  STSearchNetwork.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 18/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import PromiseKit

extension STSearchViewController {
    
    func retrieveUsers() {
        /**
         *  Stop here if there's already a query going on.
         */
        guard state != .buffering else { return }
        guard let _ = Auth.auth().currentUser?.uid else {
            retrieveUsersFailure()
            return
        }
        state = .buffering

        /**
         *  We construct the parameters for elasticsearch. Observe that there are is a substantial change when this isn't the first data round.
         */
        var parameters: Parameters = [
            "query": [
                "query_string": [
                    "fields": ["name", "username"],
                    "lowercase_expanded_terms": false,
                    "query": "\(data.query!)*"
                ]
            ],
            "size": pagination.itemsPerPage,
            "sort": [
                ["username": "asc"],
                ["_uid": "asc"]
            ]
        ]
        if pagination.dataRound > 0, let key = pagination.pivot.key, let value = pagination.pivot.value {
            let addons: [String:Any] = [
                "search_after": [
                    value,
                    "user#\(key)"
                ]
            ]
            parameters.merge(addons, uniquingKeysWith: { (first, _) in first })
        }
        
        /**
         *  The operation might be cancelled by us on purpose. In this case, we don't want to interfere with the ongoing logic flow. Fortunately, the PromiseKit automatically
         *  doesn't call the `catch` function when that happens. Read more: http://promisekit.org/docs/
         */
        let request = Alamofire.request(STConstant.kSTElasticSearchUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .authenticate(user: STConstant.kSTElasticSearchUsername, password: STConstant.kSTElasticSearchPassword)
        
        firstly { () -> Promise<Any> in
            return request.responseJSON()
            }.then { (data) -> Void in
                guard let response = data as? [String:AnyObject],
                    let hitsParent = response["hits"] as? [String:AnyObject],
                    let hits = hitsParent["hits"] as? [[String:AnyObject]], hits.isEmpty == false else {
                        throw STError.noUsersFound
                }
                self.handle(hits)
            }.catch{(error) in
                self.retrieveUsersFailure()
            }
    }
    
    /**
     *  Called if the request above failed because of networking or unknown issues.
     */
    fileprivate func retrieveUsersFailure() {
        dismissLoadingState()
        state = .idle
        pagination.stillHasToGetData = false
        tableView.reloadData()
        
        /**
         *  Very important! We only clear the containers if `dataRound` is 0, and that happens when the user has typed another content in the search bar,
         *  not when he is SCROLLING! (in that situation, the `dataRound is >= 1).
         */
        if pagination.dataRound == 0 {
            data.users.removeAll()
            tableView.reloadData()
        }
    }
}
