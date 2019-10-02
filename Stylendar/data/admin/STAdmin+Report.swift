//
//  STAdmin+Report.swift
//  Stylendar
//
//  Created by Razvan Paul Birgaoanu on 24/08/2017.
//  Copyright © 2017 Paul Berg. All rights reserved.
//

import UIKit

class STReportRef {
    var node: String {
        get {
            return "report"
        }
    }
    
    var queryUid: String {
        get {
            return "queryUid" // senderUid (reporter) + reportedUid (reported)
        }
    }
    
    var senderUid: String {
        get {
            return "senderUid"
        }
    }
    
    var reportedUid: String {
        get {
            return "reportedUid"
        }
    }
    
    var reason: String {
        get {
            return "reason"
        }
    }
    
    var user: String {
        get {
            return "user"
        }
    }
}
